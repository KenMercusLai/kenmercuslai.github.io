---
title: "When a paper plane scales up to a Boeing 747 — escalation problems for a network"
date: 2018-06-02
tags: [Scaling]
---

Scaling up a network will face a lot of issues that don't appear when it's small. In this post, let's look at what problems are they.

# Stateful applications

One of the most important decisions that make the Internet possible is to make the network stateless and push applications which are usually need to store states to end users. In the development of the network, stateful applications are inserted for certain purposes. The following are three most common ones.

* **Address Translation**. No matter which mode a NAT is working on, there must be a translation record to maintain the IP addresses mapping unless it's a stateless translation which is rare because stateless translation needs the same amount of IPs on both sides, which almost against all purposes of implementing a NAT.
* **Load Balancer**. A load balancer re-directs inward traffic to a set of applications hidden from users. The applications can respond to users' requests directly, or indirectly by send response to the load balancer to reply. Typically, the load balancer needs to hide servers for reasons in design, so the load balancer works statefully.
* **Firewall**. The basic function of a firewall is to protect unknown traffic from a lower security level (outside) accessing a network with a higher security level (inside), while keep traffic from inside accessing outside freely. To achieve this, the firewall needs to track connections initiate from inside for some time. When a traffic reaches the firewall from outside, the firewall will check if there's a connection recorded, and then allows the traffic transmit inbound or drop the traffic. Other features like NAT, HTTP states, TCP/UDP connections states, Active/Active failover are also cases of stateful application.



Besides all mentioned network applications, the active/active failover is also stateful feature almost all time. A group of devices needs to maintain some states inside and exchange them regularly to achieve the possible fastest failover.



# Convergence

The network convergence is defined as the process of a network become stable when a change happens. The goal, in general, is to minimize the convergence time to maximize the stability of a network. This factor can be ignored in a relatively small network because current computational power is strong enough and applications aren't usually critical enough. When a network is scaling up, there'll be more chances to transmit important traffic that any loss should be as little as possible, and other factors contribute to the convergence delay should be taken in consideration.



The convergence time can be divided into four parts:

* Change detection. The time to detect a change in a network, usually a failure of an interface of a link.
* Event propagation. The time to propagate the event, like flooding LSAs across the network
* Algorithm calculation. Time to perform a calculation of new information.
* RIB/FIB update. Update new tables for all routers affected.


We'll discuss these factors by using OSPF as an example, other protocols are more or less similar. The network change will be simplified as a failure in the network for the same reason.




## Detection delay

Detecting a change quickly can be the most important task for a fast convergence. In an ideal scenario, a change should be started propagating to devices once it happens. The keepalive message is can be used for this task since it is repeatedly sent to a connected device, a pre-defined number of failure of reception will be translated as a failure in the network. Similarly, a new link can also be detected by the same method. But it won't be enough for the maximum speed.



Based on the type of network, the delay in a multi-accessing network is usually larger than a physical point-to-point network. For a lower layer technology in OSI, it should be able to detect a loss of a link in the shortest interval possible, such as a P2P ethernet can report failure almost instantly by detecting network pulses, but there can be some hardware related timers that delay reporting the layer 1 events. In Gigabit Ethernet, there is a carrier-delay timer on Cisco, which is set per interface. This timer is usually used to ignore subnetwork features, so a non-critical L1 failure will never be noticed and healed under the layer 3. In most cases, it makes sense to rely on a lower layer mechanic if it is available, but more often there isn't.



## Event Propagation

After a change is detected, routing protocols will generate LSA sent to its neighbors. To completely converge the network, the notifications need to reach every router in its flooding scope. In a properly designed network, the flooding is strictly controlled. In OSPF, the scope is in one area, unless they are flooded as external. This delay can be influenced by the following factors:

1. **LSA generation delay**. An IGP uses a threshold to limit LSA generation to prevent excessive flooding in case of oscillating links. OSPF requires every generation to be delayed for a fixed interval which is one second.
2. **LSA reception delay**. The LSA reception delay is the sum of the ingress queueing delay and LSA arrival delay. This is not significant unless another massive re-convergence is occurring simultaneously, because modern routers usually use one of the highest priority queues to ensure the effectiveness of transmission.
3. **Processing delay**. This is the amount of time it takes the router to put the LSA on the outgoing flood list. This delay may be significant if the algorithm needs to recalculate. The calculation time is not the only contributor here but is usually the only one you can influence. For example, you may manually configure the flooding occurs before the calculation, which accelerates the flooding. The other component of this delay is the flooding pace and egress queues. The prior mandates the minimal interval between flooding consecutive LSAs and the later depends on the performance of an interface and a proper QoS configuration.
4. **Packet propagation delay**. This delay depends on two major factors: serialization delay at each hop and cumulative signal propagation delay across the topology. The serialization delay is almost negligible on modern links but may be significant on WAN links. The signal propagation delay is the main contributor due to the physical limitations. It heavily depends on the distance of the signal has to travel.



## Algorithm calculation complexity

The SPF algorithm is bounded as $O(L+N\cdot logN)$, where N is the number of nodes and L is the number of links in a topology under consideration. The worst case complexity for dense topologies could be a high as $O(N^2)$, but this is rare in a real-world scenario. A comparison to SPF is the Bellman-Ford algorithm which is used in the RIP with the complexity of $O(N \cdot L)$. This delay is a major limiting factor in the 80s and 90s when the routers used slow CPUs causing the calculation took seconds to complete. The Moore's Law allows modern hardware significantly reducing the impact of it but is still one of the major reason to reach a sub-second convergence.



The other problem is SPF throttling for protocols on a certain platform. It uses exponential backoff algorithm to schedule SPF calculations, in order to avoid excessive calculations in the times of high network instability but keep SPF reaction fast for stable networks.



## RIB/FIB Update

As soon as SPF computation is completed, a sequential RIB update is scheduled to reflect the changed topology. The update is then propagated to the FIB table with centralized or distributed process based on the platform architecture. The RIB/FIB update may contribute the most to the convergence time in a topology with a large number of prefixes. In such network, updating RIB/FIB may take considerable time, such as at the order of 10s.



# Management complexity

As a reader, you may come up with some ideas to overcome the problems aforementioned, such as using BFD for link detection. This is true that there is always another protocol or tool to fix a problem, but this method stacks protocols on top of each other. This won't be an issue if the number of protocols is carefully limited, but is usually failed to control. The boomed protocols will eventually exceed the number protocols that can be effectively managed.



Also, a larger network means more devices and links in it, making the network harder to be effectively managed. Things like virtual layers, such as IPv4 layer and IPv6 layer, are usually tangled and become more complexity exponentially with the size of the network.
