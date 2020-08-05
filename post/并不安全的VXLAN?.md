---
title: "并不安全的VXLAN?"
date: 2020-08-05
tags: [Protocol, Network, Security]
---

随着前几年数据中心的火热，VXLAN也成为了一个非常热门的技术。本质上来说，它和我们常见的NVGRE类似，都是在原有的数据包外面封装一层信息，然后再套上另外一层IP信息。大概就像这样：
```
| 外层Ether | 外层IP |     GRE     | VM Eth | VM IP | VM TCP | Data|  
| 外层Ether | 外层IP | UDP | VXLAN | VM Eth | VM IP | VM TCP | Data| 
```
上面这个图只是示意，并不表示GRE的头部长度和VXLAN的对比

从这个机制来看，VXLAN是绝对不安全的：任何可以访问到VXLAN网络的主机都可以在数据包中插入任意的VXLAN封装信息，甚至有窃取到同一个VXLAN segment内其他数据包的可能。如果网络的底层有通过泛洪来学习机制，那么攻击者可以重写VXLAN中MAC与VTEP的映射让流量发送到特定MAC地址。顺带一提，由于VXLAN的转发机制和VLAN相同，VLAN也有相同的问题。在这一点上两者的安全性并没有太大的不同。一旦攻击者进入了核心网络，Game Over。

但VXLAN可以通过一些微小的代价来实现加密，比如IPSec、TLS之类。所以如果一个需要VXLAN的环境中需要一定程度的安全，那么使用这些专门用于加密的通信协议来通信就是最好的选择。同时，攻击者进入核心网的技术要求远比篡改VXLAN信息大得多，如果攻击者真的能进入核心网实现上述的攻击，那我相信肯定还有其他更大的问题。

