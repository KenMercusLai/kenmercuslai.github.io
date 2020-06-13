---
title: "The number of management nodes is important, take it into your consideration"
date: 2015-08-01
tags: [Complexity]
---

The reason behind why I almost instantly became a big fan of Cisco FEX and satellite card technology is that, both of them provide tremendous complexity reduction in many aspects, like planning, managing, deploying and even the knowledge requirements for engineers.

I think no one would argue that there are a lot of great tools from CLI to GUI or whole sets of applications can improve the engineer's work effectiveness and efficiency. But all of them can only be considered as the external helps for managing the network hardwares. They can give you different point of views of your network, alarms when the network performance is worse than the set parameters, like latency or bandwidth usage.

For a very long time, network devices have worked as individuals, not a team. So we have plenty of protocols to make them cooperate like a team. For some points, those are good enough and we don't have to reinvent the wheel. But can they really satisfy us? No. When there is a switch down, the best scenario is others kicking it out of the network, and we have to replace and reconfigure it manually. Not to mention the design and deploy consideration before all of these. This is ugly. I don't want my work like this.

How about we remove all the protocols between access and upper switches/routers? How about we only have to care about the redundant connections to uppers and leave all works to the hardware? How about we simply replace the malfunction device and let the device do the rest? How about you have 1000 network nodes to configure? Let's take DC as the example. The huge datacenter will still exist with Cisco creating Nexus series. Of course.  But the ancient  STP was develop far earlier than datacenter requirements nowadays, and I don't think STP have been developed for any consideration for today's needs. I'm not saying that you can't build a datacenter with STP only. It just so complex that I don't see any good reason to stuck in it for building a large center. I have one thing to remind you — how long have the STP been patched from last time?

I'm not digging the technology details of FEX or satellite card. What I want to do is giving you a reason of why you should considerate them as least. Why don't you save your work and time when the budget is OK?
