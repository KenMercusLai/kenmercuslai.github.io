---
title: 在Ubuntu上部署SmokePing
date: 2016-05-10
tags: [Ubuntu, Linux, SmokePing]
---

![cover](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/coversmokeping.jpg)

SmokePing是rrdtool的作者Tobi Oetiker的作品，是用Perl写的，主要是监视网络性能，包括常规的ping，用echoping监www 服务器性能，监视dns查询性能，监视ssh性能等。底层也是rrdtool做支持，特点是画的图非常亮，网络丢包和延迟用颜色和阴影来表示。

#部署smokeping
##基础系统安装
这里并不需要特别说明。我选用的是Ubuntu Server 14.04。

##配置时间同步
既然是监控，第一步当然还是需要配置好时间，让我们所有的数据在时间上能进行统一。方便我们以后需要的时候能够多个数据进行综合比较。

```bash
$ sudo apt-get install ntp
```

其实到这里我们就完成了。可以检查一下：

```bash
$ ntpq -p
remote refid st t when poll reach delay offset jitter
==============================================================================
-mail.fspproduct 209.51.161.238 2 u 50 128 377 1.852 2.768 0.672
*higgins.chrtf.o 18.26.4.105 2 u 113 128 377 14.579 -0.408 2.817
+mdnworldwide.co 108.71.253.18 2 u 33 128 377 47.309 -0.572 1.033
-xen1.rack911.co 209.51.161.238 2 u 44 128 377 87.449 -5.716 0.605
+europium.canoni 193.79.237.14 2 u 127 128 377 75.755 -2.797 0.718
```

#安装与配置smokeping
##安装smokeping

```bash
$ sudo apt-get install smokeping
```
创建配置文件链接

```bash
$ cd /etc/apache2/conf-available
$ sudo ln -s ../../smokeping/apache2.conf smokeping.conf
```
启用配置

```bash
$ sudo a2enconf smokeping
$ sudo a2enmod cgid
$ service apache2 reload
```
##配置 General 文件

```bash
$ sudo vim /etc/smokeping/config.d/General
owner = Some Org
contact = org@gattis.org
mailhost = localhost
cgiurl = http://(部署的服务器IP)/cgi-bin/smokeping.cgi
# specify this to get syslog logging
syslogfacility = local0
# each probe is now run in its own process
# disable this to revert to the old behaviour
# concurrentprobes = no
@include /etc/smokeping/config.d/pathnames
```
smokeping原本要求sendmail才能运行，但这里我们使用一个work around的方式来让他先运行起来，如果有需要再配置

```bash
$ sudo vim /etc/smokeping/config.d/pathnames
sendmail = /bin/false
imgcache = /var/cache/smokeping/images
imgurl = ../smokeping/images
…
…
```

##配置报警

```bash
$ sudo vim /etc/smokeping/config.d/Alerts
to = you@your.email.com
from = monitor-smokeping@your.email.com
```
##编辑监控目标

我们现在来添加自己的监控目标。+开头的表示首层目录，++是二级目录:

```bash
+ My Company
++ My Company’s Web Server 1
++ My Company’s Web Server 2
```

我们增加一些配置：

```bash
$ sudo vim /etc/smokeping/config.d/Targets
+ My_Company
menu = My Company
title = My Company
++ Web_Server_1
menu = Web Server 1
title = Web Server 1
host = web.server.org
```

##重启服务
```bash
$ sudo service smokeping restart
$ sudo service apache2 reload
```
实际访问smokeping页面

http://(部署的IP服务器地址)/cgi-bin/smokeping.cgi
