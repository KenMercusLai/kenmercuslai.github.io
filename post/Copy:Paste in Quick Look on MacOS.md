---
title: "Copy/Paste in Quick Look on MacOS"
date: 2015-01-27
tags: [MacOS, Preview]
---

Quick Look, which is triggered by tapping space bar, of Mac OS system is the first feature that has impressed me since I switched from Windows to Mac years ago. This feature has saved me uncountable time for my from opening applications to open a file. Here is how to do copy/paste in quick look if you want to make it more powerful:

![before](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/before.png)

But the default setting does’t allow you to select the quick looked file. After a quick googling, I found a command could change this setting:

```bash
defaults write com.apple.finder QLEnableTextSelection -bool TRUE; killall Finder
```

Your Finder will relaunch after entering the above command in terminator. Just about one second, you can select the contend in Quick Look.

![after](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/after.png)

Now you can do some copy/paste in the QL window by shortcut keys since the right button menu is still disabled.

PS: if you want to disable this feature, just replace TRUE in above command into FALSE. It will be applied after relaunch.
