---
title: FRP实现内网穿透
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/JP3qDyXWDO.png
date: 2020-02-08 23:10:08
updated: 2020-02-08 23:10:08
categories: 
  - FRP
tags: 
  - FRP
---

疫情期间大家都在讨论 `远程办公`的实现，而搭建 frp 服务器进行内网穿透，可用且推荐，可以达到不错的速度，且理论上可以开放任何想要的端口，可以实现的功能远不止远程桌面或者文件共享。

## FRP是什么

简单地说，[frp](https://github.com/fatedier/frp/blob/master/README_zh.md) 就是一个[反向代理软件](https://www.zhihu.com/question/24723688)，它体积轻量但功能很强大，可以**使处于内网或防火墙后的设备对外界提供服务**，它支持HTTP、TCP、UDP等众多协议。

## 软件包下载地址

https://github.com/fatedier/frp/releases

## FRP服务端配置

```properties
[common]
bind_port = 7000
vhost_http_port = 8080

dashboard_port = 7500
dashboard_user = admin
dashboard_pwd = admin 
```

> nohup ./frps -c ./frps.ini & //后台启动命令

## FRP客户端配置

```properties
[common]
#公网ip
server_addr = x.x.x.x
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 3389
remote_port = 6000

[web]
type = http
#应用服务端口
local_port = 8088
#custom_domains = local.layne666.cn  可填公网ip或域名
#服务端设置了二级域名则用这个
subdomain = local
```

> nohup ./frpc -c ./frpc.ini & //后台启动命令