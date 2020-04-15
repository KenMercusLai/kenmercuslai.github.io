---
title: "What is ABR"
date: 2016-04-09
tags: [ABR, Streaming]
---

ABR is short for Adaptive Bitrate Streaming, which is a technique used in streaming multimedia over networks. While in the past most video streaming technologies utilized streaming protocols such RTP with RTSP, today's adaptive streaming technologies are almost exclusively based on HTTP and designed to work efficiently over large distributed HTTP networks such as the Internet.

It works by detecting a user's bandwidth in real time and adjusting the quality of a video stream accordingly. It requires the use of an encoder which can encode a single source video at multiple bit rates. The player client switches between streaming the different encodings depending on available resources. "The result: very little buffering, fast start time and a good experience for both high-end and low-end connections."

More specifically, and as the implementations in use today are, adaptive bitrate streaming is method of video streaming over HTTP where the source content is encoded at multiple bit rates, then each of the different bit rate streams are segmented into small multi-second parts. The streaming client is made aware of the available streams at differing bit rates, and segments of the streams by a manifest file.

![800px-Adaptive_streaming_overview_bit_rates_2011_07_28](media/15658731987460/800px-Adaptive_streaming_overview_bit_rates_2011_07_28.png)

# Benefits for using ABR

Adaptive bitrate streaming provides consumers of streaming media with the best-possible experience, since the media server automatically adapts to any changes in each user's network and playback conditions.

A scalable CDN is used to deliver media streaming to the Internet audiences. It receives the stream from the source at its origin server, then replicates it to many or all of its Edge cache servers. The end-user requests the stream and is redirected to the "closest" Edge server. The use of HTTP-based adaptive streaming allows the edge server to run a simple HTTP server software, whose license cost is cheap or free, reducing software licensing cost, compared to costly media server licenses (e.g. Adobe Flash Media Streaming Server). The CDN cost for HTTP streaming media is then similar to HTTP web caching CDN cost.

# Current Implementations

Since this is not an ABR comparison article, I won't dig the details for the different implementations except for Apple HTTP Adaptive Streaming.

HLS, which is short for HTTP Live Streaming, is an HTTP-based media streaming communications protocol implemented by Apple Inc. It works by breaking down streams into several small HTTP-based file downloads that load simultaneously at variable adaptive rates. It becomes a standard feature in the iPhone 3.0 and newer versions.

HLS streams can be identified by the playlist url format extension of .m3u8. These adaptive streams can be made available in many different bitrates and the client device interacts with the server to obtain the best available bitrate which can reliably be delivered.

Other implementations, such as MPEG-DASH, Adobe Dynamic Streaming for Flash,  MS Smooth Streaming, please google them for further information if you are interested in.

# Steps for building up an ABR server

## Setup a HTTP server

I choose the easiest way to build up a HTTP server with Ubuntu on vmware. 

After the server system installation has finished. Install HTTP server and config it.

	:::bash
	$sudo apt-get install lighttpd


Yes!! It's done. No further config.

## Video file

The video file I choose is an original MAD video for 烟 from Makichangu. You can [watch it online][1]. Below is the detail information about the file by Mediainfo.

	General
	Complete name                            : /Users/KenMercusLai/Downloads/test.mp4
	Format                                   : MPEG-4
	Format profile                           : Base Media / Version 2
	Codec ID                                 : mp42
	File size                                : 53.3 MiB
	Duration                                 : 3mn 51s
	Overall bit rate mode                    : Variable
	Overall bit rate                         : 1 933 Kbps
	Encoded date                             : UTC 2013-06-24 12:17:13
	Tagged date                              : UTC 2013-06-24 12:17:13
	Writing application                      : x264 0.128.2216+688+32 a17ff54 tMod [8-bit@4:2:0 X86]
	
	Video
	ID                                       : 1
	Format                                   : AVC
	Format/Info                              : Advanced Video Codec
	Format profile                           : High@L3.1
	Format settings, CABAC                   : Yes
	Format settings, ReFrames                : 5 frames
	Codec ID                                 : avc1
	Codec ID/Info                            : Advanced Video Coding
	Duration                                 : 3mn 51s
	Bit rate                                 : 1 800 Kbps
	Width                                    : 1 280 pixels
	Height                                   : 720 pixels
	Display aspect ratio                     : 16:9
	Frame rate mode                          : Constant
	Frame rate                               : 23.976 fps
	Color space                              : YUV
	Chroma subsampling                       : 4:2:0
	Bit depth                                : 8 bits
	Scan type                                : Progressive
	Bits/(Pixel*Frame)                       : 0.081
	Stream size                              : 49.6 MiB (93%)
	Writing library                          : x264 core 128 r2216+688+32 a17ff54 tMod [8-bit@4:2:0 X86]
	Encoding settings                        : cabac=1 / ref=5 / deblock=1:1:1 / analyse=0x3:0x133 / me=umh / subme=10 / psy=1 / fade_compensate=0.00 / psy_rd=0.30:0.00 / mixed_ref=1 / me_range=24 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=3 / lookahead_threads=1 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / fgo=0 / bframes=5 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=infinite / keyint_min=1 / scenecut=60 / intra_refresh=0 / rc_lookahead=60 / rc=2pass / mbtree=1 / bitrate=1800 / ratetol=1.0 / qcomp=0.50 / qpmin=0 / qpmax=69 / qpstep=4 / cplxblur=20.0 / qblur=0.5 / ip_ratio=1.40 / aq=2:0.80
	Encoded date                             : UTC 2013-06-24 12:17:13
	Tagged date                              : UTC 2013-06-24 12:17:13
	Matrix coefficients                      : BT.601
	
	Audio
	ID                                       : 2
	Format                                   : AAC
	Format/Info                              : Advanced Audio Codec
	Format profile                           : LC
	Codec ID                                 : 40
	Duration                                 : 3mn 51s
	Source duration                          : 3mn 51s
	Bit rate mode                            : Variable
	Bit rate                                 : 128 Kbps
	Channel(s)                               : 2 channels
	Channel positions                        : Front: L R
	Sampling rate                            : 48.0 KHz
	Compression mode                         : Lossy
	Stream size                              : 3.52 MiB (7%)
	Source stream size                       : 3.52 MiB (7%)
	Encoded date                             : UTC 2013-06-24 12:17:13
	Tagged date                              : UTC 2013-06-24 12:17:13

Note that, the resolution is 1080p with overall bitrate more than 1900Kbps is enough to be a HD quality. and we have to transcode it into a SD quality file and then segment them.

To be simple in the demonstration, I only reduce the bitrate. But in the real production environment, it's recommended to reduce the video resolution while reducing the bitrate to mitigate the blur for audiences of low bitrate video. Below is the re-encoding command.

	:::bash
	ffmpeg -i test.mp4 -f mpegts -acodec libmp3lame -ar 48000 -ab 64k  -vcodec libx264 -b:v 96k -flags +loop -partitions +parti4x4+partp8x8+partb8x8 -subq 5 -trellis 1 -refs 1 -coder 0 -me_range 16 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -bt 200k -maxrate 96k -bufsize 96k -rc_eq 'blurCplx^(1-qComp)' -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -level 30  -g 30 -async 2 test-low.mp4

Now we have to segment these two files.

	:::bash
	ffmpeg -i test.mp4   -codec copy -map 0 -f segment -vbsf h264_mp4toannexb -flags -global_header -segment_format mpegts -segment_list test.m3u8 -segment_time 3 test%03d.ts
	
	ffmpeg -i test-low.mp4   -codec copy -map 0 -f segment -vbsf h264_mp4toannexb -flags -global_header -segment_format mpegts -segment_list test-low.m3u8 -segment_time 3 test-low%03d.ts

After the processes, we the segmented video files are ready to go, there will be a lot of files in your folder depends on the original video length.
![Screen Shot 2014-02-03 at 9.37.39 A](media/15658731987460/Screen%20Shot%202014-02-03%20at%209.37.39%20AM.png)

Here are the info for the first segments of each.

HD file:

	General
	ID                                       : 1 (0x1)
	Complete name                            : /Users/KenMercusLai/Downloads/test000.ts
	Format                                   : MPEG-TS
	File size                                : 4.24 MiB
	Duration                                 : 22s 356ms
	Overall bit rate mode                    : Variable
	Overall bit rate                         : 1 585 Kbps
	
	Video
	ID                                       : 256 (0x100)
	Menu ID                                  : 1 (0x1)
	Format                                   : AVC
	Format/Info                              : Advanced Video Codec
	Format profile                           : High@L3.1
	Format settings, CABAC                   : Yes
	Format settings, ReFrames                : 5 frames
	Codec ID                                 : 27
	Duration                                 : 22s 439ms
	Nominal bit rate                         : 1 800 Kbps
	Width                                    : 1 280 pixels
	Height                                   : 720 pixels
	Display aspect ratio                     : 16:9
	Frame rate mode                          : Variable
	Color space                              : YUV
	Chroma subsampling                       : 4:2:0
	Bit depth                                : 8 bits
	Scan type                                : Progressive
	Writing library                          : x264 core 128 r2216+688+32 a17ff54 tMod [8-bit@4:2:0 X86]
	Encoding settings                        : cabac=1 / ref=5 / deblock=1:1:1 / analyse=0x3:0x133 / me=umh / subme=10 / psy=1 / fade_compensate=0.00 / psy_rd=0.30:0.00 / mixed_ref=1 / me_range=24 / chroma_me=1 / trellis=2 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=-2 / threads=3 / lookahead_threads=1 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / fgo=0 / bframes=5 / b_pyramid=2 / b_adapt=2 / b_bias=0 / direct=3 / weightb=1 / open_gop=0 / weightp=2 / keyint=infinite / keyint_min=1 / scenecut=60 / intra_refresh=0 / rc_lookahead=60 / rc=2pass / mbtree=1 / bitrate=1800 / ratetol=1.0 / qcomp=0.50 / qpmin=0 / qpmax=69 / qpstep=4 / cplxblur=20.0 / qblur=0.5 / ip_ratio=1.40 / aq=2:0.80
	Matrix coefficients                      : BT.601
	
	Audio
	ID                                       : 257 (0x101)
	Menu ID                                  : 1 (0x1)
	Format                                   : AAC
	Format/Info                              : Advanced Audio Codec
	Format version                           : Version 4
	Format profile                           : LC
	Muxing mode                              : ADTS
	Codec ID                                 : 15
	Duration                                 : 22s 357ms
	Bit rate mode                            : Variable
	Channel(s)                               : 2 channels
	Channel positions                        : Front: L R
	Sampling rate                            : 48.0 KHz
	Compression mode                         : Lossy
	
	Menu
	ID                                       : 4096 (0x1000)
	Menu ID                                  : 1 (0x1)
	Duration                                 : 22s 356ms
	List                                     : 256 (0x100) (AVC) / 257 (0x101) (AAC)
	Service name                             : Service01
	Service provider                         : FFmpeg
	Service type                             : digital television
	
SD file:

	General
	ID                                       : 1 (0x1)
	Complete name                            : /Users/KenMercusLai/Downloads/test-low000.ts
	Format                                   : MPEG-TS
	File size                                : 185 KiB
	Duration                                 : 3s 670ms
	Overall bit rate mode                    : Variable
	Overall bit rate                         : 410 Kbps
	
	Video
	ID                                       : 256 (0x100)
	Menu ID                                  : 1 (0x1)
	Format                                   : AVC
	Format/Info                              : Advanced Video Codec
	Format profile                           : High@L3.0
	Format settings, CABAC                   : No
	Format settings, ReFrames                : 4 frames
	Codec ID                                 : 27
	Duration                                 : 3s 712ms
	Bit rate                                 : 96.0 Kbps
	Width                                    : 1 280 pixels
	Height                                   : 720 pixels
	Display aspect ratio                     : 16:9
	Frame rate mode                          : Variable
	Color space                              : YUV
	Chroma subsampling                       : 4:2:0
	Bit depth                                : 8 bits
	Scan type                                : Progressive
	Stream size                              : 43.5 KiB (23%)
	Writing library                          : x264 core 125
	Encoding settings                        : cabac=0 / ref=1 / deblock=1:0:0 / analyse=0x3:0x111 / me=hex / subme=5 / psy=1 / psy_rd=1.00:0.00 / mixed_ref=0 / me_range=16 / chroma_me=1 / trellis=1 / 8x8dct=1 / cqm=0 / deadzone=21,11 / fast_pskip=1 / chroma_qp_offset=0 / threads=3 / lookahead_threads=1 / sliced_threads=0 / nr=0 / decimate=1 / interlaced=0 / bluray_compat=0 / constrained_intra=0 / bframes=3 / b_pyramid=2 / b_adapt=1 / b_bias=0 / direct=1 / weightb=1 / open_gop=0 / weightp=2 / keyint=30 / keyint_min=16 / scenecut=40 / intra_refresh=0 / rc_lookahead=30 / rc=cbr / mbtree=1 / bitrate=96 / ratetol=1.0 / qcomp=0.60 / qpmin=10 / qpmax=51 / qpstep=4 / vbv_maxrate=96 / vbv_bufsize=96 / nal_hrd=none / ip_ratio=1.41 / aq=1:1.00
	
	Audio
	ID                                       : 257 (0x101)
	Menu ID                                  : 1 (0x1)
	Format                                   : MPEG Audio
	Format version                           : Version 1
	Format profile                           : Layer 3
	Mode                                     : Joint stereo
	Mode extension                           : MS Stereo
	Codec ID                                 : 3
	Duration                                 : 3s 672ms
	Bit rate mode                            : Constant
	Bit rate                                 : 64.0 Kbps
	Channel(s)                               : 2 channels
	Sampling rate                            : 48.0 KHz
	Compression mode                         : Lossy
	Stream size                              : 28.7 KiB (15%)
	
	Menu
	ID                                       : 4096 (0x1000)
	Menu ID                                  : 1 (0x1)
	Duration                                 : 3s 670ms
	List                                     : 256 (0x100) (AVC) / 257 (0x101) (MPEG Audio)
	Service name                             : Service01
	Service provider                         : FFmpeg
	Service type                             : digital television

## Create video webpage

Upload those segmented files onto the Ubuntu in vmware, then we have to create a simple page to play the video.

In /var/www folder.

	:::bash	
	$cat index.html
	<!DOCTYPE html>
	<html>
	<head>
	    <title>ABR</title>
	</head>
	
	<body>
	    <div id="player">
	        <video autoplay="true" controls="controls" width="800" height="600">
	            <source src="ss.m3u8" type="audio/x-mpegURL" />
	 Your browser does not support HTML5 streaming!
	        </video>
	    </div>
	</body>
	</html>

	$cat ss.m3u8
	#EXTM3U
	#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=500000
	http://192.168.123.106/test-low.m3u8
	#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=2000000
	http://192.168.123.106/test.m3u8
	
Also, you can create page that only play HD or SD video for comparison.

#Test

Here is the test video

<iframe width="560" height="315" src="//www.youtube.com/embed/G-ZZnTKU4to" frameborder="0" allowfullscreen></iframe>

Please note the different quality between video time 0:17. I'll give the vmware image link for download in the end of the post, you can download it to test it by your self.

#Q&A 

1. **Q**: The switch between video streaming with different quality is not smooth in the test video.

    **A**: I believe it's the video recording issue, I can't recreate it without recording.

2. **Q**: Can I use 2-pass transcoding setting?

    **A**: No. Or you will see a blurry I-frame “popping” at the beginning of each 10 second video segment.
    
3. **Q**: How can I set the m3u8 file mime type in other HTTP server?

    **A**: application/x-mpegURL
    
4. **Q**: Why can't I see the video switching into higher quality?/Why can't I see the video quality switch from SD to HD and them switch back.

    **A**: Fluctuating between different quality video streaming will significantly reduce audience's viewing experience. So ABR has algorithm to reduce the unnecessary  switching. 

# Ken's View

* ABR is essential for video providers provides non-stop video service in variance network situations
* Migration from traditional streaming to ABR could be easy. Since the CPs have already provided video in different quality for variant devices.
* NO special or advance feature is needed for ABR server, a dump server is good enough. A server cluster may easy to deploy in production environment.

PS: After this, I've given up to deploy it in my Home. 

	_(:3」∠)_

---

Download link: [Part.1](https://dl.dropboxusercontent.com/u/299446/Ubuntu%2064-bit.7z.001) [Part.2](https://dl.dropboxusercontent.com/u/299446/Ubuntu%2064-bit.7z.002)

username/password: cisco/cisco

PS2: I'm not a Cisco employee.

[1]: http://www.bilibili.tv/video/av616901/
[2]: https://www.networktsukkomi.me/2014/01/07/real-world-network-simulation/
