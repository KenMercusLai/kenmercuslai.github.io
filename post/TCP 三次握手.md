---
title: "TCP 三次握手"
date: 2020-07-25
tags: [Network, Protocol]
---

TCP建立连接时，实际上时建立两个单向连接来进行双向通信，双方都需要一个发起连接，接收和确认的过程。过程如下：

![img](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fext-cerebrum%2F2u-6TEISwB.png?alt=media&token=98204c92-e8f1-4d30-b067-3b4019b70a7f)

Reference: https://www.guru99.com/tcp-3-way-handshake.html

1. 发起方发送SYN，附带一个随机的序列号A
2. 接收方收到以后回复ACK，序列号A+1。同一包内也附带一个SYN flag和一个随机序列号B
3. 发起方收到SYN+ACK后，可以通过A+1的编号来确定自己发起的连接已经（单向）建立。同时回复B+1的SYN给接收方
4. 接收方收到B+1的ACK，确定单向连接打开。