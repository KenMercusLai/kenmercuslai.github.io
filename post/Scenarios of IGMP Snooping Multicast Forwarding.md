---
title: "Scenarios of IGMP Snooping Multicast Forwarding"
date: 2016-04-16
tags: [IGMP, Multicast]
---

![cover](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/cover.png)

I've discussed what is IGMP snooping and its forwarding rules for different packets in my [last post](https://kenmlai.me/what-is-igmp-snooping/). I just want to give some typical scenarios in IGMP snooping for your better understanding.


## Scenario 1: Switch forwarding multicast traffic to a multicast router and hosts

![1](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/11.png)

In the topology shown above, the switch acting as a pure L2 device interconnects multicast router, which directly connects to the Source A for multicast group 239.10.1.1, Source B which is the source of 225.100.100.1 and four hosts. All interfaces on the switch belong to the same VLAN.

The switch receives IGMP queries from the multicast router on P1, so IGMP snooping learns that interface P1 is a multicast-router interface. Any IGMP general queries it receives on this interface will be forwarded to all host interfaces on this switch, and membership reports it receives from hosts will be forwarded to the multicast-router interface (P1).

In the given example, Host A and C are the members of multicast group 239.10.1.1, and multicast traffic of 239.10.1.1 will thus be forward on P2 and P4, but not to Host B and D (P3 and P5)

Host B responds the membership queries of 225.100.100.1. The switch adds interface P3 to its table as a member interface for 225.100.100.1 and forward all multicast traffic of it from Source B to Host B. The switch will also forward multicast traffic of 225.100.100.1 to multicast-router interface P1.


## Scenario 2: Switch forwarding multicast traffic to another switch

![2](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/12.png)

In the network shown above, a multicast source is connected to Switch A, which is connected to another switch. Both switches have receivers of the multicast source from Switch A connected. Both switches are acting as L2 devices and all interfaces on the switches are members of the same VLAN.

Po1 will be recognized as a multicast-router interface because of the IGMP queries received from a multicast router. All general IGMP queries received on Switch A will be sent to all other interfaces on this switch, so Po6 will be a multicast-router interface for Switch B because of receiving IGMP queries.

Switch B forwards membership report to its multicast-router interface Po6, which is then forwards to the multicast router by Switch A as the same as membership report from Host B.

**It's recommended to configure Po6 on Switch B as a static multicast-router interface** though this topology works fine for most of the time. The reason is that if Switch B receives join messages from its hosts before it learns which interface is the multicast-router interface, it does not forward those reports to Switch A. When Switch A receives multicast traffic, it will not forward traffic to Switch.


## Scenario 3: Switch connected to hosts only (w/o IGMP querier)
![3](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/13.png)

In the topology shown above, a switch connects to multicast source and hosts. Because there is no multicast router in this topology, no IGMP querier will be sent. Without the querier to respond to, a host does not send membership reports periodically. As a result, even if the host sends join message to join a multicast group, its membership times up.

For making IGMP snooping to work correctly in this network so that the switch forwards multicast traffic to Hosts A and C only, we can:

- statically configure Po2 and Po4 as group-member interfaces
- enable the switch as IGMP querier so that hosts can dynamically join and maintain the membership of the group


## Scenario 4: L2/L3 Switch forwarding multicast traffic between VLANs

![4](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/14.png)

In this topology, we can easily analyze the interfaces' statuses according to previous examples. In a pure L2 environment, traffic will not be forwarded between VLANs. To make Host C receive multicast from VLAN 10, the switch must be permitted routing traffic between VLAN 10 and VLAN 20, while PIM is enabled on a switch to perform the multicast routing.
