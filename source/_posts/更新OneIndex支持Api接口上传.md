---
title: 更新OneIndex支持Api接口上传
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/07/11/lcyzNlM59v.png
date: 2021-07-01 00:08:12
updated: 2021-07-01 00:08:12
categories: 
  - OneIndex
tags: 
  - OneIndex
---

## 更新背景

> OneIndex 项目源码地址：https://github.com/Layne666/oneindex

之前买的 `OneDrive` 世纪互联账号失效了，`OneIndex` 就一直没用了，废弃掉了。但最近偶然间又遇到一个商家，发现卖得不贵就又买了一个玩玩。

之前我的图床用的是自己阿里云服务器搭建的 `Chevereto` 图床（支持 API 接口上传图片），不过图片加载速度受限于服务器的带宽，所以再买了 `OneDrive` 世纪互联账号之后，便考虑用 `OneIndex` 的图床功能。

但用过 `OneIndex` 的都知道，`OneIndex` 虽然支持图床设置，但是只支持页面上传，无奈之下，只能自己动手继续改一下 `OneIndex` 代码了。

## API 接口上传文件

> OneIndex 支持 API 接口上传文件后，用 Typora + PicGo 写作也太舒服了吧！

* 接口地址：/api/v1/upload
* POST参数名：file
* 请求头：{"authcode":"xxxxxx"}
  * authcode：对应OneIndex图床配置的授权码

![image-20210630234829890](https://pan.layne666.cn/images/2021/07/11/5XHmj2vQtF.png)

![image-20210630234929694](https://pan.layne666.cn/images/2021/07/11/a1nSJkI4kp.png)
