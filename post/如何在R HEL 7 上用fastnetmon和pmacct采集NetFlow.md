---
title: "如何在R HEL 7 上用fastnetmon和pmacct采集NetFlow"
date: 2020-07-31
tags: [Linux, NetFlow, Grafana, pmacct, fastnetmon]
---

最近由于苦于公司已有的监控系统存在太多的问题，各种流程又太过缓慢，所以干脆考虑自己从头建一套新的监控，在大家还没从官僚的流程中反应过来的时候直接用既成事实来代替整个流程。😊

现在针对网络监控的平台已经非常成熟了，免费的Nagios和Zabbix都是非常不错的选择。不仅配置简单，而且在功能上一点都不缺。不过由于需要经常性的对数据进行交叉分析，我比较习惯能用一个平台来管理所有的数据。在比较之后，我便打算直接用telegraf来采集SNMP数据，加上pmacct和fastnetmon来采集NetFlow，前台直接套用一个Grafana作为dashboard。虽然整个流程上不如Nagios和Zabbix方便，但是在强在数据展示的灵活和可配置型。

整个流程都是基于公司的RHEL 7.8系统

![img](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fext-cerebrum%2F2bOKv8nQfw.png?alt=media&token=fc04b3e2-0515-4902-9f0a-eb1ff0c297f5)

# fastnetmon 与 influxdb 安装

fastnetmon本身的安装非常傻瓜化，只需要按照[官方的教程](https://fastnetmon.com/install/)即可。安装完成后，我关闭了所有ban相关的选项，因为我只用它来监控，而不用作出反应。

需要注意的一点就是`/etc/fastnetmon.conf`中网络的大小设置要考虑服务器的性能，特别是内存大小。内存不够的时候会出现无法正常工作的情况。具体的内存需求可以从安装文档中提到的日志中查看。同时，如果有不只一种协议（比如同时使用NetFlow和sFlow），那么它们的监听端口不能相同。

如果配置无误，那么可以运行 `/opt/fastnetmon/fastnetmon_client` 来查看接收到的数据状态。此路径可能不同，可以自己摸索一下。

influxdb可以完全按照[官方教程](https://docs.influxdata.com/influxdb/v1.8/introduction/install/)来安装。没有任何坑。安装完成后，只需要在`/etc/influxdb/influxdb.conf`设置如下内容

```bash
[[graphite]]
  enabled = true
  bind-address = "127.0.0.1:2003"
  database = "dc1"
  protocol = "tcp"
  consistency-level = "one"
  name-separator = "."
  # batch-size / batch-timeout requires InfluxDB >= 0.9.3  batch-size = 5000
  # will flush if this many points get buffered  batch-timeout = "1s"
  # will flush at least this often even if we haven't hit buffer limit
  templates = [
    "fastnetmon.hosts.* app.measurement.cidr.direction.function.resource",    
    "fastnetmon.networks.* app.measurement.cidr.direction.resource",    
    "fastnetmon.total.* app.measurement.direction.resource"  ]
```

同时在`/etc/fastnetmon.conf`中加上这一部分即可 
```bash 
graphite = on 
graphite_host = 127.0.0.1 
graphite_port = 2003 
graphite_prefix = fastnetmon
```

最后一步就是启动influxdb

```bash
systemctl start influxdb
```
# pmacct 与 mariadb 安装

pmacct本身不能直接导出数据到influxdb，不过Grafana的好处就是可以连接各种不同后台来获取数据。本着实用的原则，我直接选用了pmacct本身就支持的mariadb来存储数据。

mariadb可以直接通过yum安装并完成基本的设置

```bash
sudo yum install mariadb-server mariadb-devel /usr/bin/mysql_secure_installation 
sudo systemctl restart mariadb
```
pmacct在RHEL下就没有提供包可以直接安装，需要从头编译 
```bash
yum install libtool libpcap-devel  
git clone https://github.com/pmacct/pmacct cd pmacct ./autogen.sh ./configure --enable-mysql make sudo make install
```
整个编译过程非常快，完成之后就可以进行初始配置了。sql文件夹下面有v1-v9不同版本的数据库定义，可以按照自己的需求来选择。因为我的环境中都是Netflow v9，所以我就直接采用了v9的数据库定义。 
```bash 
cd sql 
cp pmacct-create-db_v9.mysql pmacct-create-db_v9.mysql.bak 
sudo vi pmacct-create-db_v9.mysql
```
这里我们需要稍微修改一下数据库定义，[以避免后面运行的时候报错](https://github.com/pmacct/pmacct/blob/master/sql/README.timestamp)。 
```bash 
drop database if exists pmacct; create database pmacct; use pmacct; drop table if exists acct_v9;  create table acct_v9 (    tag INT(4) UNSIGNED NOT NULL,    class_id CHAR(16) NOT NULL,    mac_src CHAR(17) NOT NULL,    mac_dst CHAR(17) NOT NULL,    vlan INT(2) UNSIGNED NOT NULL,    as_src INT(4) UNSIGNED NOT NULL,    as_dst INT(4) UNSIGNED NOT NULL,    ip_src CHAR(45) NOT NULL,    ip_dst CHAR(45) NOT NULL,    port_src INT(2) UNSIGNED NOT NULL,    port_dst INT(2) UNSIGNED NOT NULL,    tcp_flags INT(4) UNSIGNED NOT NULL,    ip_proto CHAR(6) NOT NULL,     tos INT(4) UNSIGNED NOT NULL,     packets INT UNSIGNED NOT NULL,    bytes BIGINT UNSIGNED NOT NULL,    flows INT UNSIGNED NOT NULL,    stamp_inserted DATETIME NOT NULL,    stamp_updated DATETIME,    timestamp_min DATETIME NOT NULL,    timestamp_max INT UNSIGNED NOT NULL,    PRIMARY KEY (tag, class_id, mac_src, mac_dst, vlan, as_src, as_dst, ip_src, ip_dst, port_src, port_dst, ip_proto, tos, stamp_inserted, timestamp_min, timestamp_max) );
```
然后便可以用这个新的文件来创建表和pmacct的配置文件 
```bash 
mysql -u root -p < pmacct-create-db_v9.mysql 
mkdir -p /etc/pmacct 
sudo vim /etc/pmacct/pmacctd.conf
```
配置文件如下 
```bash
daemonize: true 
# Interface on which 'pmacctd' listens                                   
interface: eth0                         
# Sets the maximum number of concurrent writer processes the plugin is 
allowed to start sql_max_writers: 25                         
# Enables the optimization of the statements sent to the RDBMS) 
sql_optimize_clauses: true 
# Forces 'pmacctd' to join together IPv4/IPv6 fragments 
pmacctd_force_frag_handling: true 
# Enables debug 
debug: false 
# If set to true adds two new fields, timestamp_min and timestamp_max 
pmacctd_stitching: true 
# Plugins to be enabled 
plugins: mysql[c]                                 
# Aggregates used for the sole purpose of IP accounting 
aggregate[c]: src_host, dst_host, proto 
# Defines the SQL database to use 
sql_db[c]: pmacct                                
# In SQL and mongodb plugins this defines the table to use 
sql_table[c]: acct_v9              
# Defines the password to use when connecting to the server 
sql_passwd[c]: xxxxx                   
# Defines the username to use when connecting to the server 
sql_user[c]: root                                  
# Time interval, in seconds, between consecutive executions of the plugin cache scanner 
sql_refresh_time[c]: 6                        
# Sets timestamp to seconds 
timestamps_secs: true             
# this directive enables buffering of data transfers between core process and active plugins 
plugin_buffer_size: 10240 
plugin_pipe_size: 1024000 
# Specifies the maximum number of bytes to capture for each packet 
snaplen: 1500
```
在第一次运行的时候，请先将daemonize设置为false，并把debug设置为true。否则数据无法正常写入也无法知道错误的原因。都完成之后，就是运行pmacct来采集数据了 
```bash
pmacctd -f /etc/pmacct/pmacctd.conf
```
pmacct采集到的数据对于通常的监控是非常够用的，唯一的缺点就是其本身不区分流量是流出还是流入，有时候在统计的时候会比较麻烦（比如统计所有从网内流出的流量）。而这个时候fastnetmon就可以非常简单的完成这个任务了。
同时，由于pmacct是工作在混杂模式，所以无所谓监听哪一个端口。所有送到网卡的数据包它都能接收，这样也不会和fastnetmon冲突，也避免了需要同时发送两份数据流的问题。