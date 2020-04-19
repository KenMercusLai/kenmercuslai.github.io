---
title: "Experiences about CloudFlare"
date: 2014-06-08
tags: [CDN, CloudFlare]
---

![cover](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/cover1231321.jpg)

I spent about three hours to migrate my tech blog from [OpenShift](http://openshift.com) & [CloudFlare](http://cloudflare.com) to GitHub again, after my moving all from GitHub to OpenShift about 2 month ago. Experience with OpenShift & CloudFlare was frustrating and awful. It didn’t hit any expectations that I thought before the first migration.

# Why I want to use CDN

Choosing a free hosting by OpenShift for me is mesmerized by its potential customization in the future, rather than cost consideration. Also, OpenShift also gave me an easy click-to-install process while providing the customization possibility, which was so fascinating.

After the quick installation and migration from Github, I noticed that it may potentially have been blocked by the GFW in China. I confirmed this and chose to solve it by using the free CDN service to cache my webpages rather than switching back. With a quick googling, I found there were a lot of people discussing about CloudFlare to accelerate page accessing and get rid of the GFW problems, which were all I want. I then registered an account and start deploying on it.

# What is CloudFlare & How it works

CloudFlare is a free service that accelerates and secures your website by acting as a proxy between your visitors and host servers. With CloudFlare, you can protect your website against malicious visitors, save bandwidth and reduce average page load times.It caches parts of websites that are static. For example, it catches things like images, CSS, and Javascript. It’s very conservative for its caching because of the dynamic content. It also refreshes the cache relatively frequently, so files are never more than a few hours old. Even being conservative, however, typically 50% of the resources on any given web page are cacheable. If we have a local copy of the web files then the visitor could have an extremely fast accessing speed from a local data center.

If the request is for a type of resource it doesn’t cache, or if it doesn’t have a current copy in the cache, then it makes a request from its data center back to the origin server. Because it is relatively high scale, it can almost always get premium routes from data centers back to most places on the Internet. As a result, while it may seem counter-intuitive, it is sometimes the case that the number of “hops” a visitor request makes going through the CloudFlare network is less than the number of “hops” that they would have made going to the origin web server directly.

According to its official website, they have servers all over the world. As we can see, no Chinese mainland is included. But with servers in HK and Tokyo, it should be at least ok for visitors from China.

![network-map](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/network-map.jpg)

# Experience of CloudFlare

It worked well at first, and then just connection reset or extremely slow speed. I googled about this and there were some similar use cases. Since this service is quite new in mainland, these information is usually overwhelmed by other unrelated things.

The root cause of this problem may be from its geo-location acceleration accessing, which will redirect mainland traffic to HK, which is the nearest, cache data center. However, international Internet connection gateways are located in Shanghai and Beijing, which are mostly connected to Japan and US. Direct connection between Shanghai and HK is enough. As the result, traffic which has been redirected to HK will go through Japan or at least go out of Mainland and then connect to HK or just be dropped in the somewhere.

I thought CloudFlare doesn’t want to solve this mess of Mainland(I’m not blaming it, no one can actually solve it), I thought I had to give it up.

# Ken’s View

Like all fast-growing or exotic products, they all forget about one truth - the world of the Internet is divided into two parts, Mainland China and the other. These two worlds are just so distinct that there is no rule can serve both at the same time.

I can't say CloudFlare is a valuable service, but at least it has some like accessing acceleration, offline browsing, analytics, threat protection, and so on. If I'm living outside of mainland China, I'd like to use its services to improve my blog experience like [etherealmind](http://etherealmind.com/). And I'm also would be attempting another time if it has extended cache server into mainland.
