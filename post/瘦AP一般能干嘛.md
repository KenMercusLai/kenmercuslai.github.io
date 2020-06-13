---
title: "瘦AP一般能干嘛"
date: 2015-10-10
tags: [Wifi, AP]
---

在讨论无线的时候，通常都会问到：“瘦AP都有些什么功能？” 或者 “AP和WLC各负责什么？”

瘦AP一般的功能包括：

Real-Time 802.11/MAC Functionality:

* Beacon Generation
* Probe Response
* Power management/Packet buffering
* 802.11e/WMM scheduling, queueing
* MAC layer data encryption/decryption
* 802.11 control messages
* Data Encapsulation/De-Encapsulation
* Translational Bridging (H-REAP Local Switching)
* Fragmentation/De-Fragmentation

其余剩下的功能都由WLC完成，包括但不限于：

Non Real-Time 802.11/MAC Functionality:

* Association/Disassociation/Reassociation requests/response
* 802.11e/WMM (Wi-fi Multimedia)
* 802.1X/EAP (Port based authentication)
* Key management
* 802.11 Distribution Services
* 802.11 STA (Client/Station) Services (Auth/Deauth/Privacy)
* Wired/Wireless Integration Services

