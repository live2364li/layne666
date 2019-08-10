---
title: win10搭建Vagrant+VirtualBox环境
date: '2019-07-25 12:44:13'
tags: [Vagrant]
categories: 虚拟机
---

## Vagrant是什么？

vagrant是一个操作虚拟机的工具.是一个基于Ruby的工具，用于创建和部署虚拟化开发环境。    通过命令和配置文件来管理虚拟机,很快就能完成一套开发环境的部署,并可以打包传播,统一了开发环境,也解决了重复配置环境的麻烦。

## Vargant的好处

1. Vagrant会创建共享文件夹，用来在主机和虚拟机之间进行资源共享
2. Vagrant通过添加box镜像进行快速部署，部署完毕后可以通过package进行打包分发，避免二次重建环境
3. Vagrant可以使用puppet、chref等管理工具进行自动化配置部署
4. Vagrant支持单机模拟多台机器，且支持一个配置文件Vagrantfile就可以跑分布式系统
<!--more-->
## 准备工作

1. vagrant_2.2.5_x86_64.msi
2. VirtualBox-6.0.8-130520-Win.exe
3. vagrant-centos-7.box

## 进行安装

### 安装VirtualBox

VirtualBox安装就不多说了，一直下一步下一步就行了。

### 安装Vagrant

Vargrant下载win版的，然后一直下一步下一步就行了。

### 下载package.box

去vagrant官网下载一个package.box 文件，box文件就是一个系统的镜像文件，镜像下载地址：[http://www.vagrantbox.es](http://www.vagrantbox.es/)

### 把虚拟机加载到box容器中

下载好之后，在该目录下执行命令加载镜像文件到Vagrant中去:

```bash
vagrant box add centos7 xxxx.box
```

centos7是给虚拟机起的名字 ,随意写。然后可以通过以下命令查看，当前vagrant下有那些可用

```bash
$ vagrant box list
centos7 (virtualbox, 0)
```

### 初始化虚拟机

在你想要创建虚拟机的目录下，执行以下命令进行初始化

```bash
vagrant init centos7
```

会生成一个Vagrantfile文件,该文件就是Vagrant的配置文件。

若要安装docker，则修改Vagrantfile文件，如下：

```bash
config.vm.provision "shell", inline: <<-SHELL
  sudo yum remove docker docker-common docker-engine
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce
  sudo systemctl start docker
SHELL
```

### 启动虚拟机

在该目录下输入:

```bash
vagrant up 
```

打开Oracle VM VirtualBox即可看到当前虚拟机的状态信息。

## Vagrant连接

### 虚拟机相关登录信息

在创建虚拟机的目录下，执行以下命令进行连接：

```bash
$ vagrant ssh
[vagrant@localhost ~]$
```

### ssh登录

使用第三方客户端来进行连接，例如xmoba、putty、Xshell等

```
ssh: 127.0.0.1  
端口: 2222  
用户名: vagrant  
密码: vagrant 
```

这里使用Xshell来登录

![](../images/win10搭建Vagrant+VirtualBox环境/1.jpg)

![](../images/win10搭建Vagrant+VirtualBox环境/2.jpg)

找到刚刚上面生成的秘钥: 

```
E:/OS_WORK/Node1/.vagrant/machines/default/virtualbox/private_key
```

然后点击确定，进行连接

### 公网访问登录

修改Vagrantfile文件，放开下面代码的#

```
# config.vm.network "public_network"
```

### root账号登录

vagrant登陆后，切换到root账号

```bash
$ sudo -i
```

设置root的密码
```bash
$ passwd
```

修改 `/etc/ssh/sshd_config` 文件，把 PermitRootLogin 属性 改为yes，并把前面的#去掉, PasswordAuthentication 改为yes，并且去掉#。

保存退出，重启sshd服务

```
$ systemctl restart sshd
```

再通过xshell连接的时候，就可以用账号密码，root来登录了

参考博文：https://blog.csdn.net/u011781521/article/details/80275212