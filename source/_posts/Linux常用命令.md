---
title: Linux常用命令
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/FapvLcUyzB.jpg
date: 2019-01-08 22:35:06
updated: 2019-02-08 17:19:46
categories: 
  - Linux
tags: 
  - Linux
---

## 关机&重启命令

**基本介绍:**

```bash
shutdown -h now     表示立即关机
shutdown -h 1       表示1分钟后关机
shutdown -r now     表示立即重启
halt                关机，作用和上面一样
reboot              现在重新启动计算机
sync                把内存的数据同步到磁盘
```

**细节说明**
<font color=#FF0000>**不管是重启系统还是关闭系统，首先要运行sync命令，把内存中的数据写到磁盘中！**</font>

## 用户管理命令

### 添加用户

```bash
useradd layne       添加layne这个用户
```

**细节说明**

1. 当创建用户成功后，会自动地创建和用户同名的家目录
2. 也可以通过 useradd -d 指定目录 新的用户名，给新创建的用户指定家目录

### 给用户指定或修改密码

```bash
passwd layne        添加layne这个用户
```

### 删除用户

```bash
userdel layne       删除layne这个用户
```

**应用案例**

1. 删除用户xiaoming，但是要保留家目录
userdel layne
2. 删除用户以及用户主目录
userdel -r layne

**细节说明**

* 在删除用户时，我们一般不会把家目录删除！

### 查询用户信息

```bash
id layne           查看layne这个用户信息
```

![](https://pan.layne666.cn/images/2021/12/02/p76o820ynU.png)

**细节说明**

- 当用户不存在时，返回“无此用户”！

### 切换用户

```bash
su - layne         切换到layne这个用户
```

**细节说明**

1. 从权限高的用户切换到权限低的用户，不需要输入密码，反之需要。
2. 当需要返回到原来用户时，使用exit指令

#### **对于 su , su - , sudo的理解**

```
su和su - 的区别： 
相同点：默认情况下 su 与 su - 都是切换成root用户
不同点：su 切换用户却不切换工作环境 , su - 同是切换用户与工作环境, 如果Shell环境不一样将会出现无法找到对应命令的问题。

由于用户通过 su root 命令直接获取root权限，从而造成用户的权限太大，也就可能给系统造成危险。
为了既保证系统的安全又可以执行相应命令，sudo 也就以此诞生。

sudo 通过/etc/sudoers配置文件来限制用户的权限。
```