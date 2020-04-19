---
title: "让matplotlib配色方案更加美观的三种方式"
date: 2016-04-07
tags: [matplotlib, Python]
---

![cover](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/cover.jpg)

不管是谁，第一眼看到matplotlib配色方案的时候都至少不会觉得他很漂亮。我遇到很多使用Python的人问过我用什么module可以画出漂亮的图表，我的答复都是matplotlib。当然这对他们来讲都是一个比较吃惊的回答。

matplotlib配色如此“不舒适”的原因我不太清除，不过我希望通过他提供的灵活配置方式来得更加美观的图表。

## matplotlib配色方案

让我很意外的是，[官方网站](http://matplotlib.org)提供了一套不错的方案。虽然整体感觉比较“硬”，但确实比默认的好很多了。更好的是，在颜色方案的下面还配有代码来帮助你理解如何使用。

网址在这里： [color example code](http://matplotlib.org/examples/color/colormaps_reference.html)


## brewer2mpl

通过pip安装[brewer2mpl](https://pypi.python.org/pypi/brewer2mpl/1.4)包可以直接获得一些不错的方案。
![cbrewer_previe](https://raw.githubusercontent.com/KenMercusLai/kenmercuslai.github.io/pics/uPic/cbrewer_preview.jpeg)

这里给出一个简单的定义全局配色方案的例子：

```python
import brewer2mpl

# brewer2mpl.get_map args: set name  set type  number of colors
bmap = brewer2mpl.get_map('Set2', 'qualitative', 7)
colors = bmap.mpl_colors

import matplotlib as mpl
mpl.rcParams['axes.color_cycle'] = colors
```

## 自由搭配

如果你对这些免费的方案并不满意，那么一些商业软件的方案或许能够满足你。[Tableau](http://www.tableausoftware.com)公开了自己应用的配色方式，你可以通过[这里](http://tableaufriction.blogspot.ro/2012/11/finally-you-can-use-tableau-data-colors.html)来选择自己的方案。

当然，如果你找出了一个自己最满意的方案，并且希望每次都应用他时，不妨考虑把配色方案写入matplotlibrc的axes.color_cycle。
