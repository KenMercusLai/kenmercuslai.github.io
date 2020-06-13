---
title: NO-NAT configuration on Cisco ASA Firewall
date: 2015-01-28
tags: [Firewall, ASA, Cisco]
---

Cisco ASA firewall has upgraded its command line at the version 8.3 and changed a lot of configurations from their previous style. I recently faced two cases about NO-NAT in both version and want to leave a quick note here.

Example details:

- inside IP address: 1.1.1.0/24
- outside IP address: 2.2.2.0/24
- traffic go through from inside interface to outside interface

## Before 8.3

An access-list is needed to filter the interested traffic. This access-list is then used in NAT 0 to ensure all traffic defined in it is not NATed.

```
access-list NO-NAT permit ip 1.1.1.0 255.255.255.0 2.2.2.0 255.255.255.0
nat (inside) 0 access-list NO-NAT
```

## Begin in 8.3

ASA gave up the configuration style used before for NO-NAT and mandated to use network object. Network object was introduced earlier and more flexible ([Configure Object Groups](http://www.cisco.com/c/en/us/td/docs/security/asa/asa82/configuration/guide/config/objectgroups.html)), though, it was popular in configurations. The new style uses two network objects to define traffic which doesn't need to be NATed, then render them in new NAT configuration style.

```
object network INSIDE
subnet 1.1.1.0 255.255.0.0
object network OUTSIDE
subnet 2.2.2.0 255.255.0.0
nat (inside,outside) source static INSIDE INSIDE destination static OUTSIDE OUTSIDE
```
