---
title: 解决Hexo的command not found问题
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/eseiUBRVRm.jpg
date: 2020-04-05 10:10:01
updated: 2020-04-05 10:10:01
categories: 
  - Hexo
tags: 
  - Hexo
---

在 Linux 环境上安装完 [Hexo](https://hexo.io/) 之后，发现报如下错，找不到`hexo`命令：

```shell
[root@xxx ~]# hexo version
-bash: hexo: command not found
```

### 解决方案：

#### 找到对应安装的位置

```shell
[root@xxx ~]# find / -name hexo 
/usr/local/nodejs/lib/node_modules/hexo-cli/bin/hexo
/usr/local/nodejs/bin/hexo
/var/lib/jenkins/workspace/blog/node_modules/.bin/hexo
/var/lib/jenkins/workspace/blog/node_modules/hexo
/var/lib/jenkins/workspace/blog/node_modules/hexo/lib/hexo
/var/lib/jenkins/workspace/blog/node_modules/hexo/node_modules/.bin/hexo
/var/lib/jenkins/workspace/blog/node_modules/hexo/node_modules/hexo-cli/bin/hexo
/var/lib/jenkins/workspace/blog/node_modules/hexo/bin/hexo
```

#### 添加环境变量

```shell
[root@xxx bin]# ln -s /usr/local/nodejs/lib/node_modules/hexo-cli/bin/hexo /usr/local/bin/hexo
```