---
title: img标签访问图片返回403 forbidden问题
date: 2019-04-25 20:49:46
tags: 
---
解决这个问题只需要在头部添加一个meta 

`<meta name="referrer" content="no-referrer" />`<!--more-->

referrer的几种状态
![referrer状态](../images/img标签访问图片返回403-forbidden问题/img403.png) 

a标签的referrer

`<a href="http://example.com" referrer="no-referrer|origin|unsafe-url">xxx</a>`


原文地址：https://www.cnblogs.com/mttcug/p/8109036.html

