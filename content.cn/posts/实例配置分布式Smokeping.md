---
title: "实例配置分布式Smokeping"
date: 2016-05-17
tags: [Linux, Smokeping, Tutorial, Distribution]
---

在[前一篇文章中](https://kenmlai.me/zai-ubuntushang-bu-shu-smokeping/)，简单的介绍了如何在Ubuntu 14.04中安装smokeping，安装之后smokeping是以单机的形式来运行。但是在这样的情况下，安装smokeping的主机测试的是自己到被检测点之间的状态。又或者单独一台主机的性能已经完全不能满足监控的需求。这时，我们需要考虑采用分布式smokeping来进行监控。分布式smokeping相比单点有这样一些重要的优势：

- 分担单台主机负担。
- 可以通过不同的网络环境监控对于同一监控点。
- 避免干扰因素。


# 分布式Smokeping架构

Smokeping采用Master/Slave的主从结构架构进行分布式部署。默认开启Master和Slave所有的探针检测远程主机（Master监测功能可以通过配置关闭）。一个Master可以管理多个Slave，而且Slave配置起来也很简单。

Slave从master上获取自己的配置信息，所有的检测数据以及web呈现都在Master上。Slave只负责按照从Master获取的配置信息进行数据检测，所以Master/Slave的架构也只需要维护Master的配置文件即可，其他的信息Slave都会动态获取到。

简单说，一个Slave就是一个单独的实例。Slave的配置信息来自于Master,不是来自于本地配置文件，这样就减少了大量的维护成本。Slave在完成每一轮的作业任务后，就会尝试连接Master提交自己的结果。如果无法连接到Master，这个结果将会和下一轮的结果一块发送给Master，Master收到结果后，将检测的数据存储在本地的数据文件中，以便于重启了Smokeping实例后，不会丢失这些数据。

Smokeping分布式的检测方式是被动模式，由Slave启动时向Master发起连接。主从通信验证是通过类似于rsync的密码认证方式，在启动slave节点时指定–shared-secret=filename来和主进行密码验证。

从官方获取的Master/Slave的架构图可以看出，Slave是将采集的结果汇集给Master。

```
[slave 1]     [slave 2]      [slave 3]
   |             |              |
   +-------+     |     +--------+
           |     |     |
           v     v     v
         +---------------+
         |    master     |
         +---------------+
```


# 分布式Smokeping配置


## Master配置部分

配置一个主从结构，需要在Master的配置文件中添加Slave的部分，所有Slave需要被定义在Master的Slave section中。

1.在配置文件中定义Slave

```bash
*** Slaves ***
secrets=/usr/local/smokeping/etc/smokeping_secrets.dist
# 定义通信用的秘钥文件，里面包含slave的名字以及对应密码

+ Slave1                # slave的名字
display_name=Slave1    # slave的别名
location=changzhou    # 这个字段用来定义slave主机的位置，类似于description
color=0000ff        # slave收集的数据在图像中显示的颜色，
```

2.将定义的Slave节点分配给你需要监控的主机

```bash
*** Targets ***
# 定义一个菜单，这个值将会作为data下的一个目录名被创建，属于这个菜单下所有数据都会被存放在这个目录下
++ changzhou
# 定义web上显示的菜单名
menu = 常州机房
# 定义web上显示的头部名
title = 常州机房

# 定义一个主机，这个主机的数据将会被存放在　data/changzhou/29gui目录下
+++ 29gui<-(xxx.xxx.xxx.xxx.xxx)
# web上显示的菜单名，可点击
menu = 29柜<-(xxx.xxx.xxx.xxx)
# 图表头部名称
title = 29柜<-(xxx.xxx.xxx.xxx)
# 报警
alerts = someloss
# slave节点
slaves = Slave1
# 被监控的主机IP或者域名
host = xxx.xxx.xxx.xxx
```

3.Master和Slave通信的秘钥文件

通信用的秘钥文件内容为“slave的名字:密码”,这里需要注意秘钥文件的权限，由于smokeping的master/slave是通过smokeping程序进行验证的，所以这个**秘钥文件owner必须是smokeping进程的运行用户身份，并且权限为600**。

```bash
# echo "Slave1:helloworld" > /usr/local/smokeping/etc/smokeping_secrets.dist
# chown daemon:daemon /usr/local/smokeping/etc/smokeping_secrets.dist
# chmod 600 /usr/local/smokeping/etc/smokeping_secrets.dist
```


# Slave配置部分

Slave端实际上不需要太多的配置，只需要将smokeping正确安装即可，具体可参照 [Smokeping的安装](http://kenmlai.me/在ubuntu上部署smokeping/) 一文。

1.创建master与slave的密码文件

```bash
# echo "helloworld" > /usr/local/smokeping/etc/secrets
# chown daemon:daemon /usr/local/smokeping/etc/secrets
# chmod 600 /usr/local/smokeping/etc/secrets
```

2.启动slave

可以使用`/usr/local/smokeping/bin/smokeping --help`
 观察到与slave有关的几个参数如下：

<table><thead><tr><th align="left">参数</th><th align="left">解释</th></tr></thead><tbody><tr><td align="left">–master-url</td><td align="left">当smokeping运行在slave模式下，使用该项指定master的访问url（web接口，用以通信）</td></tr><tr><td align="left">–slave-name</td><td align="left">默认情况下，不指定改项时，slave连接到master后，master会以slave的hostname作为slavename，如果不希望这样做，就需要手动指定改选项</td></tr><tr><td align="left">–shared-secret</td><td align="left">和master通信认证的密码文件</td></tr><tr><td align="left">–cache-dir</td><td align="left">当smokeping运行在slave模式下，临时数据存放在master上的目录路径</td></tr><tr><td align="left">–pid-dir</td><td align="left">slave模式下，其pid存放的目录路径。可选参数，默认继承–cache-dir参数的值</td></tr></tbody></table>3.启动slave

```bash
# /usr/local/smokeping/bin/smokeping --master-url=http://xxx.xxx.xxx.xxx/smokeping.cgi --cache-dir=/usr/local/smokeping/cache/ --shared-secret=/usr/local/smokeping/etc/secrets --slave-name=tuosi --logfile=/usr/local/smokeping/slave.log
```

写成脚本，启动方便一点，内容如下：

```bash
#!/bin/bash
#
# when: 2013/10/18
# who: http://blog.coocla.org

SMKEPING=/usr/local/smokeping/bin/smokeping
MASTERURL=http://xxxx/smokeping.cgi
SLAVENAME=tuosi
CACHEDIR=/usr/local/smokeping/cache
SECRET=/usr/local/smokeping/etc/secrets
LOGFILE=/usr/local/smokeping/slave.log

if [ -f $PIDFILE ] ; then
    PID=`cat $PIDFILE`
    if kill -0 $PID 2>/dev/null ; then
        echo "smokeping is running with PID $PID"
        exit 0
    else
        echo "smokeping not running but PID file exists => delete PID file"
        rm -f $PIDFILE
    fi
else
    echo "smokeping (no pid file) not running"
fi

if $SMKEPING --master-url=$MASTERURL --slave-name=$SLAVENAME --cache-dir=$CACHEDIR --shared-secret=$SECRET --logfile=$LOGFILE > /dev/null; then
    echo "smokeping started"
else
    echo "smokeping could not be started"
fi
```

很简单的一个脚本，没有做过多的判断。

一些个人新的：

1. 定义好smokeping和web服务器的运行用户，因为会涉及一些权限；
2. smokeping的运行用户调用rrdtools进行数据收集绘图，所以存放rrd数据文件，以及图像文件的目录smokeping的运行用户一定要拥有写权限；
3. web前端对于该况图和监控图的展示，是通过web服务器的运行用户通过smokeping.cgi对所绘制的图像进行展示，所以web服务器的运行用户一定也要对图像目录拥有读写选项；
4. 对于web页面的中文显示，无外乎与设置web的字符集以及所在的操作系统要支持对应的字符集；
5. 对于其他的rrd文件不更新，web页面没有图像，或者web页面有图像但没有数据，这些一般都是因为以上权限设置不正确或者rrdtool安装不正确导致的；
6. 对于master/slave的架构，首先也明白其认证的原理，一定要将slave-name和master配置文件中配置的slave节点名以及密钥文件中的节点名相对应；
7. 对于master的密钥文件(包含slave节点名和密码)，slave的密码文件(只有密码)，要这样去思考，这样两个文件的内容都是smokeping通过smokeping的api进行交互通信的，那么交互通信的用户肯定是smokeping的运行用户，因此这两个文件的属主一定要属于smokeping的运行用户，其次要想到rsync的配置，其文件的属性权限一定要是600；
