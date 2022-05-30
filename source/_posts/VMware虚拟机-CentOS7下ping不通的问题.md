---
title: VMware虚拟机 CentOS7下ping不通的问题
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/gPZLGtH32b.png
date: 2019-08-25 16:51:49
updated: 2019-08-25 16:51:49
categories: 
  - CentOS
tags: 
  - CentOS
---

### 前言

最近学习 docker 需要搭个 Centos7 的环境，之前在笔记本上搭过，现在在台式电脑上搭的时候就直接把虚拟磁盘文件拷贝过来了，vm 启动当前虚拟机正常，就是没得网，经过一顿捣鼓之后，终于好了，在此记录一下这问题的解决过程！✍

```shell
[root@localhost ~]# ping baidu.com
ping: baidu.com: 未知的名称或服务
```

### 解决方法

在 VMware 虚拟机任务栏——编辑（E）——虚拟网络编辑器——VMnet8——查看本机的子网 ip，将其写入 `ifcfg-ens33` 文件里面的 ip 进行修改即可！

![](https://pan.layne666.cn/images/2021/12/02/cSX0tMTEQN.png)

### 修改 ifcfg-ens33 文件

1. 将 `BOOTPROTO="dhcp"` 改成 `BOOTPROTO="static"`

2. 将 `ONBOOT="on"` 改成 `ONBOOT="yes"`

3. 在后面加上

   ```properties
   IPADDR=192.168.133.2 //此次不要设置成0，否则怎么调试都有问题
   NETMASK=255.255.255.0
   GATEWAY=192.168.133.2
   DNS1=8.8.8.8 //配谷歌8.8.8.8的DNS，要是有问题就配成与网关一致
   ```
   
4. 输入 `service network restart` 命令重新启动网卡