---
title: img标签访问图片返回403 forbidden问题
copyright_author_href: https://layne666.cn
cover: https://bed.layne666.cn/images/2021/02/12/ebac918b385d1a9dd9d137a536039472.png
date: 2019-04-25 20:49:46
updated: 2019-04-25 20:49:46
categories: 
  - HTTP
tags: 
  - HTTP
---

解决这个问题只需要在头部添加一个meta 

`<meta name="referrer" content="no-referrer" />`

referrer的几种状态
![ebac918b385d1a9dd9d137a536039472.png](https://bed.layne666.cn/images/2021/02/12/ebac918b385d1a9dd9d137a536039472.png)

a标签的referrer

`<a href="http://example.com" referrer="no-referrer|origin|unsafe-url">xxx</a>`

原文地址：https://www.cnblogs.com/mttcug/p/8109036.html

