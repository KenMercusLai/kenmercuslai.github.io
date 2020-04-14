---
title: "Controller discussion is excessive, we need more about other aspects"
date: 2016-04-24
tags: [SDN, controller]
---

Ever since SDN has been revealed and considered as the future in the industry by the public. There are abundant discussions about OpenFlow, ACI, NSX, etc. The main focus right now is the software part including southern API, northern API and more.

<!-- more -->

The discussion about those new features which SDN could bring us has instigated the aspires of this Old-thought-with-new-implementation for network fellows who have been suffered for a long time for the poor management & controllability of network entities.

As I always standing on the side that SDN needs a complete solution covered almost all main specs, even though we probably won’t bring it to the real life. But it is a theoretic way to validate the concepts & abilities for my point.

OpenFlow is not SDN as we all have known about. Controllers are neither. Infrastructure which lies under controller in the SDN stack and also is THE fundamental network seems to have been ignored by most people.

There is at least one thing to have a detail discussion even we only focus OpenFlow — functionality differentiates between versions. For instance, if we set up a controller with a feature only supported in a higher version, how could we solve this issue if we only have lower version support in physic devices? Also lacking practical transition plan from the traditional network we are using today to this hi-tech future also refrains us.

More, even VMware and Cisco have their own solution & plan for SDN, we still cannot guarantee they can fit each other. Since customers won’t bring two SDN systems for the exact same purpose obviously, the best choice for them may be waiting for their cross-platform support which we have no insight about the time or just keep themselves out of SDN and waiting.

Meanwhile, flaws could happen even for the biggest companies like Cisco & Huawei. I could specify big flaws about mature switches & routers from Juniper & Huawei though I haven’t worked in them for one single minute. SDN also depends on a lot of chip and hardware work in the lower part of it. The possibility of defects is higher than those we have used for 10 years in design and manufacture. Vendors could make new devices, but we have to pay all.

So, if vendors are really thinking about improving network with their implementation of SDN, infrastructure, a transition plan is equally important to controllers. Also, please give us an integrated, solid solution of SDN. Thank you all kind vendors.
