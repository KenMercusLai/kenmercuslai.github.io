---
title: "BPDU filter VS BPDU guard"
date: 2016-04-02
tags: [BPDU]
---

I read [Michael’s new blog post](http://blog.michaelfmcnamara.com/2014/01/network-is-down-please-help/) about how to reduce the possibility of the network unavailable time. He talked about BPDU filter and BPDU guard in his second point, and it was quite a confusion that they seem the same. But actually, they are not.

BPDU is short for the phrase Bridge Protocol Data Unit, which is part of the STP that helps describe and identify attributes of a switch port. BPDUs allow for switches to obtain information about each other.

As the name says, BPDU filter filters BPDUs in both directions. BPDU filter will prevent inbound and outbound BPDU but will remove portfast state on a port if a BPDU is received. Enabling BPDU filtering on an interface is the same as disabling spanning tree on it and can cause spanning-tree loops.

On the other hand, BPDU Guard keeps an eye open for any BPDU’s entering the interfaces that are enabled this feature. The port will disable as soon as the first BPDU is received, by shutting the port down.


# Ken’s View

The only devices which can reliably create and transmit BPDU’s are switches. Our main aim to have a predictable topology and not allow other switches outside our control onto our network. According to the features, the Best Practices to enable BPDU Guard only on access ports (to end-user devices) so that any end user devices on these ports that have BPDU Guard enabled are not able to influence the Spanning-tree topology, while BPDU filter could considerate as a disable-STP-on-port feature.
