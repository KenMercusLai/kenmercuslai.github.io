---
title: "What is IGMP Snooping"
date: 2016-03-02
tags: [IGMP]
---

## What does IGMP Snooping Do

IGMP snooping is used to monitor the traffic of IGMP protocol between hosts and multicast-enabled routers. The switch uses it to learn which interface has an interested receiver and forward multicast traffic only to these interfaces. This feature could save bandwidth by allowing it to send traffic only needed, rather than flooding all multicast packets to all interfaces.


## IGMP Snooping and Forwarding Interfaces

To determine how to forward multicast traffic, IGMP snooping maintains a “table” about the interfaces information:

- multicast-router interfaces — interfaces lead to multicast routers or IGMP queriers.
- group-member interfaces — interfaces lead to hosts that are members of multicast groups.

IGMP snooping learns[^1] about interfaces by monitor IGMP traffic. If an interface receives IGMP queries or PIM updates, it will be added to the table as a multicast-router interface. If an interface receives IGMP group membership reports, IGMP snooping adds it to the table as a group-member interface.

While both types are configurable by hand which is static, the dynamic learned information in the table about interfaces will age and be removed after missing updates.


## Forwarding Rules

Multicast traffic received on a switch interface with IGMP snooping is enabled is forwarded according to the following rules.

IGMP traffic is forwarded as follows:

- IGMP general queries are forwarded to all other interfaces in the VLAN.
- IGMP group-specific queries are forwarded to all other interfaces that are members of the group in the VLAN.
- IGMP reports are forwarded to all multicast-router interfaces in the same VLAN

Non-IGMP multicast traffic is forwarded as follows:

- A multicast packet destines to 224.0.0.0/24 is flooded to all other interfaces on the same VLAN.
- An unregistered multicast packet is forwarded to all multicast-router interfaces on the same VLAN.
- A registered multicast packet is forwarded only to those group-members interfaces which have interested receivers and all multicast-router interfaces in the same VLAN.

On my next post, I will show you some scenarios about IGMP snooping multicast forwarding.

[^1]: An IGMP querier is required to exist in the network
