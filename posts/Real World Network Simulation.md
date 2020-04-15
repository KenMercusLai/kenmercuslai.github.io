---
title: "Real World Network Simulation"
date: 2016-04-29
tags: [Simulation]
---

## Why we need network simulation

As a network engineer, I have to spend a lot of time in the lab or test environment on testing concepts, configuration, troubleshooting and so on. This is also true for people whose work environment is related to a network such as developers, DBAs. The problem here is that the lab sometimes so perfect that it cannot emulate the real world flaws like latency, packet loss, re-order or bandwidth limitation. So we need an emulator to test a program or system on a simulated network connection which is faulty or errors prone. This is a valuable tool to make sure your application works when the network has packet loss, jitter or high latency. Loss emulation is a standardized method to simulate a bad network connection using a system on your local LAN. Using the local LAN keeps your testing environment secure and allows full control over the topology.

Every time I have this need, I prefer to use [tc](http://lartc.org/manpages/tc.txt).


## What can tc do?

In short, tc is a queueing discipline for bandwidth management, like shaping, policing, scheduling or dropping. Since there are articles about how to use it from the command line man page, I don’t want to create one more redundancy. I prefer to give some quick useful command to let you understand it. If you think any one of those is interesting, then you can dig the document.

A simulated network that has:

- latency delay 100ms +-40ms with the next random element depending 15% on the last packet sent
- packet loss causes 0.5% of the packets to be randomly dropped and lost, each successive probability depends by 25% on the last one. (Probn = .25 * Probn-1 + .75 * Random)
- packet duplication set to 1% of packets sent
- Packet corruption introduces a single bit error at a random offset in the packet. This will affect 0.1% of the traffic.
- Packet reordering means the first 5% of packets (with a correlation of 50%) will get sent immediately.

```bash
sudo tc qdisc add dev eth0 root netem delay 100ms 40ms 15% loss 0.5% 25% duplicate 1% corrupt 0.1% reorder 5% 50%
```

remove from config:

```bash
sudo tc qdisc del dev eth0 root netem
```

## The Ken’s view

tc is very useful and worthy of spending some time on it. And there are some useful links here: [netem](http://www.linuxfoundation.org/collaborate/workgroups/networking/netem), [Queueing Disciplines for Bandwidth Management](http://lartc.org/howto/lartc.qdisc.html)

