---
title: "How to install ffmpeg on OpenShift"
date: 2016-05-02
tags: [OpenShift, FFMpeg, Linux]
---

We, ProjectMercury, recently wanted to move encoding jobs into OpenShift to make our workflow more efficiently. After some effort, we made it work. Here is a quick note of the process

Pre-requests:
 1. git
 2. rhc

I assume you already have both of them

After sshed into your openshift virtual machine. Using following commands to install ffmpeg

```bash
cd $OPENSHIFT_DATA_DIR
mkdir bin
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
wget http://ffmpeg.org/releases/ffmpeg-2.0.1.tar.gz

tar -xvf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix=$OPENSHIFT_DATA_DIR/bin --bindir=$OPENSHIFT_DATA_DIR/bin
make
make install
export PATH=$OPENSHIFT_DATA_DIR/bin:$PATH

cd $OPENSHIFT_DATA_DIR
tar -xvf ffmpeg-2.0.1.tar.gz
cd ffmpeg-2.0.1
make
make install
```

If you’d like to use other version of related packages, just replace the URL and respectively folder name. Another thing I want to mention is that be sure about the free disk space, the compiling process will consume a lot.
