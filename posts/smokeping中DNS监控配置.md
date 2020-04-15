---
title: smokeping中DNS监控配置
date: 2016-05-15
tags: [SmokePing, DNS]
---

smokeping的一个很大的优势是其丰富的probe。最近根据客户需求，需要监控DNS解析的延时情况。不过smokeping中DNS监控配置遇到了一些预想之外的问题。

根据[官方的文档](http://oss.oetiker.ch/smokeping/probe/DNS.en.html)，一共需要两个步骤：

1. 在Probes配置中增加相应的DNS probe
2. 在Targets中增加自己的需要监控的DNS域名

本来应是很简单的过程，不过实际实际的配置过程中，没有对每个参数的意义完全理解，导致自己走了一点点弯路。

以使用dig作为probe为例，最小化配置如下：

- 在Probes中增加相应的配置

```
+DNS

binary = /usr/bin/dig
```

- 在Targets中增加需要监控的目标

```
+ mytarget
probe = DNS
#以下三个参数都必须配置，否则无法采集数据
host = my.host
lookup = www.example.org
server = ns1.someisp.net
```

自己尝试的过程中，由于host, lookup, server三个参数没有配置齐全。所以导致很长时间都没有出图。所以，如果你需要配置使用dig作为probe来监控DNS服务质量，请一定要配置这三个参数。
