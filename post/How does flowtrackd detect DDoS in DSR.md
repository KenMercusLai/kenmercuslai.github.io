---
title: "How does flowtrackd detect DDoS in DSR"
date: 2020-07-19
tags: [Network, Security, DDoS]
---

Cloudflare recently announced flowtrackd which can detect DDoS in [DSR]([[Direct Server Return]]) scenarios. It's quite interesting since most DDoS protections need the gateway working in the reverse proxy mode, in which the traffic coming and leaving through the same device. Then the gateway can track connection statuses since it observes every packet. I am not an employee of Cloudflare and have no insight of how flowtrackd is designed, but I'd like to have an educated guess. 

Here're some things we need to know before talking about how flowtrackd works. Let's go over them in case you can't remember.

# TCP connection establishment and termination
A TCP connection between the client and server is identified by Src_IP:Src_Port:Dst_IP:Dst_Port. Hence, there can be one TCP connection between the pair of Src_IP:Src_Port and Dst_IP:Dst_Port. 

Whenever the client tries to establish a TCP connection to the server. A 3-handshake is required in the following steps:
- The client sends a TCP packet with SYN flag and a random SEQ number A
- Once the server receives the SYN packet, it returns a TCP packet with ACK flag and ACK number A+1, where the SYN flag is also set with another random SEQ B
- Similarly, once the client receives the packet from the server with ACK number A+1, it confirm the uni-directional tunnel is established from its side. It also responds an ACK packet with ACK number B+1 to acknowledge the server
- When the server have the ACK packet with number B+1, a second uni-directional tunnel is set up and the TCP connection is established

Similarly, a termination requires both tunnels to be torn down from both side:

* A FIN packet is sent to the other end, and the other end responds with a ACK

# Packet visibility in reverse proxy and DSR
Reverse proxies have visibility of all packets in all connections, but DSR can see incoming traffic only as shown in the following picture (borrowed from Cloudflare).

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fext-cerebrum%2FkapfY4RTS5.png?alt=media&token=759b1335-f89e-4a21-8d95-8f2211c93b23)

# My guess of how flowtrackd works
Indeed we have less information in DSR, but it doesn't mean we can't detect DDoS.

I believe the logic is straight forward and I present it as a flow chart to save time for you and me.

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGjCoFREXG4gICAgQVtQYWNrZXTCoGluwqB3aXRowqBJUF9hOlBPUlRfYTpTRVFfYSBJUF9iOlBPUlRfYl3CoC0tPiBCe2ZsYWd9XG4gICAgQsKgLS0-fFNZTnzCoER7SVBfYTpQb3J0X2HCoElQX2I6UE9SVF9iIHJlY29yZGVkfcKgLS0-wqB8WWVzfCBEcm9wW0Ryb3BdXG4gICAgRMKgLS0-wqB8Tk98wqBHW1JlY29yZMKgSVBfYTpQb3J0X2EgSVBfYjpQT1JUX2JdXG4gICAgQsKgLS0-fEFDS3zCoEV7SVBfYTpQb3J0X2HCoElQX2I6UE9SVF9iIHJlY29yZGVkfcKgLS0-wqB8WWVzfMKgQWxsb3dcbiAgICBFwqAtLT7CoHxOb3zCoERyb3BcbiAgICBCwqAtLT58RklOfMKgRntJUF9hOlBvcnRfYcKgSVBfYjpQT1JUX2IgcmVjb3JkZWR9XG4gICAgRsKgLS0-wqBSZW1vdmVfcmVjb3JkW1JlbW92ZSBJUF9hOlBvcnRfYcKgSVBfYjpQT1JUX2JdIFxuICAgIFJlbW92ZV9yZWNvcmQgIC0tPiB8WWVzfMKgQWxsb3dcbiAgICBGwqAtLT7CoHxOb3zCoERyb3BcbiAgICBEcm9wIC0tPiBDb3VudGVyW0lQX2EgY291bnRlcisxXSAtLT4gQ291bnRlcl9UaHJlc2hvbGR7SVBfYSBjb3VudGVyID4gSVAgVGhyZXNob2xkfVxuICAgIENvdW50ZXJfVGhyZXNob2xkIC0tPiB8WWVzfCBERG9TW0REb1MgRGV0ZWN0ZWQhXVxuICAgIEctLT5PcGVuX0NvdW50ZXJbSVBfYSBvcGVuIGNvbm5lY3Rpb24gY291bnRlciArMV0gLS0-IE9wZW5fVGhyZXNob2xke0lQX2Egb3BlbiBjb25uZWN0aW9uIGNvdW50ZXIgPiBPcGVuIGNvbm5lY3Rpb24gVGhyZXNob2xkfSAtLT4gfFllc3wgRERvU1xuICAgIE9wZW5fVGhyZXNob2xkIC0tPiB8Tm98IEFsbG93XG4iLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)](https://mermaid-js.github.io/docs/mermaid-live-editor-beta/#/edit/eyJjb2RlIjoiZ3JhcGjCoFREXG4gICAgQVtQYWNrZXTCoGluwqB3aXRowqBJUF9hOlBPUlRfYTpTRVFfYSBJUF9iOlBPUlRfYl3CoC0tPiBCe2ZsYWd9XG4gICAgQsKgLS0-fFNZTnzCoER7SVBfYTpQb3J0X2HCoElQX2I6UE9SVF9iIHJlY29yZGVkfcKgLS0-wqB8WWVzfCBEcm9wW0Ryb3BdXG4gICAgRMKgLS0-wqB8Tk98wqBHW1JlY29yZMKgSVBfYTpQb3J0X2EgSVBfYjpQT1JUX2JdXG4gICAgQsKgLS0-fEFDS3zCoEV7SVBfYTpQb3J0X2HCoElQX2I6UE9SVF9iIHJlY29yZGVkfcKgLS0-wqB8WWVzfMKgQWxsb3dcbiAgICBFwqAtLT7CoHxOb3zCoERyb3BcbiAgICBCwqAtLT58RklOfMKgRntJUF9hOlBvcnRfYcKgSVBfYjpQT1JUX2IgcmVjb3JkZWR9XG4gICAgRsKgLS0-wqBSZW1vdmVfcmVjb3JkW1JlbW92ZSBJUF9hOlBvcnRfYcKgSVBfYjpQT1JUX2JdIFxuICAgIFJlbW92ZV9yZWNvcmQgIC0tPiB8WWVzfMKgQWxsb3dcbiAgICBGwqAtLT7CoHxOb3zCoERyb3BcbiAgICBEcm9wIC0tPiBDb3VudGVyW0lQX2EgY291bnRlcisxXSAtLT4gQ291bnRlcl9UaHJlc2hvbGR7SVBfYSBjb3VudGVyID4gSVAgVGhyZXNob2xkfVxuICAgIENvdW50ZXJfVGhyZXNob2xkIC0tPiB8WWVzfCBERG9TW0REb1MgRGV0ZWN0ZWQhXVxuICAgIEctLT5PcGVuX0NvdW50ZXJbSVBfYSBvcGVuIGNvbm5lY3Rpb24gY291bnRlciArMV0gLS0-IE9wZW5fVGhyZXNob2xke0lQX2Egb3BlbiBjb25uZWN0aW9uIGNvdW50ZXIgPiBPcGVuIGNvbm5lY3Rpb24gVGhyZXNob2xkfSAtLT4gfFllc3wgRERvU1xuICAgIE9wZW5fVGhyZXNob2xkIC0tPiB8Tm98IEFsbG93XG4iLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)

The flow won't work well if we don't have some assistance, which I have in mind are proper timers, especially the open connection timeout timer.