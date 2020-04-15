---
title: "自动翻墙路由器制作 Part. 2"
tags: [GFW, Router, DIY]
date: 2016-05-12
---

在[上一篇文章](http://kenmlai.me/自动翻墙路由器制作-part-1/)中，我们已经搞定了路由器刷机问题，这一次我们需要做的是进行路由器的基本配置。

# 基本配置

我们首先不考虑NAS BT下载设备的存在。我们无法正常访问国外的一些网站，除了链接被reset之外，还有一个原因是DNS污染。DNS污染让域名不能解析正确的IP地址，而是给出黑洞IP，让我们所有的链接都超时。不过也正式这样的黑洞IP，让我们在后面可以用来做健康检查。为了避免DNS污染，我们所有的DNS解析都要通过国外的DNS服务器进行解析。常用的有OpenDNS和Google DNS两个，用哪个没有本质区别，全看个人喜好。baidu差的原因，就是文章都是重复的。如果你搜索ddwrt翻墙的DNS设置，我相信你很难找到有实际参考价值的文章。DD-WRT内置了两种DHCP服务器，标准的uDHCPd和DNSMasq。由于我们需要使用DNSMasq来实现防DNS污染的功能，所以DNSMasq是必须打开的。设置如下：为了让AP下面所有的设备都能获得我们设置的外国DNS服务器，我们通常有两种方式进行设置。


## DHCPd

默认情况下，DD-WRT会启用DNSMasq作为DHCP服务端，这就导致了在设置页**Setup**->**Basic Setup**->**Network Setup**->**Network Address Server Settings (DHCP)**部分的三条Static DNS设置后不起作用。
![dhcpd](media/15658731987221/dhcpd.png)

因为这里的选项是对应标准uDHCPd服务端的，就算设置了分配给DHCP客户端的DNS服务器地址还是路由器的内网IP，也就是还会默认以ISP提供的DNS解析服务器为准。这时就需要取消下面选项中的Use DNSMasq for DNS，让标准服务提供客户端DNS解析服务器地址。![dns](media/15658731987221/dns.png)

虽然当然这样会消耗更多的内存，不过现在路由器性能强劲，这点消耗其实不算什么。


## DNSMasq

上策就是到**Services**->**Services**->**DNSMasq**->**Additional DNSMasq Options**中填入如下内容：dhcp-option=6, 8.8.4.4, 8.8.8.8，这样应用设置并让客户端重新连接刷新DHCP信息后，就可以看到已经在使用指定的DNS解析服务器地址了。


## 打开JFFS2

我们已经完成了基本的设置，接下来需要做的就是开辟一个即使重启也能保存我们脚本的空间——JFFS2。在**Administration**->**Management**->**JFFS2 Support**中，选择Enable JFFS2
![jffs2](media/15658731987221/jffs2.png)

虽然启用了JFFS2，不过默认情况下可用空间是0，我们需要选择Enable Clean JFFS2，然后在页面的最下方选择Apply。如果没有问题，就能看到可用空间已经不为0 KB了。
![jffs2_2](media/15658731987221/jffs2_2.png)

PS: 实际数字可能和图上不同。PS 2: 每次Enable Clean JFFS2，然后Apply之后。Clean JFFS2都会自动变成Disable。PS 3: 有些型号的路由器需要无论怎么Clean JFFS2都是无法使用的。这时请Google。


## SSH

虽然我们默认可以telnet上路由器来写脚本，但这远没有直接打开SSH服务用SFTP上传本地完成的脚本方便。虽然这不是必须配置的内容，但我还是强烈建议打开SSH。在**Services**->**Services**->**Secure Shell**中，打开SSHd。

![ssh](media/15658731987221/ssh.png)

这里最重要的就是SSHd必须打开，其他的可以按照自己的需要来设置。当然，有了SSH，下面的telnet就别忘记关闭了。在下一篇文章中，我们就要开始配置脚本让我们的流量能够自动根据我们访问的内容使用不同的网关。
