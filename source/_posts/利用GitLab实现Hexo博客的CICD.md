---
title: 利用 GitLab 实现 Hexo 博客的 CI/CD
cover: https://pan.layne666.cn/images/2021/12/02/BGF0C1Xr9j.png
date: 2020-09-05 16:26:10
updated: 2020-09-05 16:26:10
categories: 
  - Hexo
tags: 
  - Hexo
  - GitLab
---

# Gitlab CI介绍

```text
Gitlab是常用的开源git代码管理工具之一，随着发展也推出了ci/cd解决方案．
顾名思义具体来说ci/cd主要完成以下两个工作．
    ci(持续构建)
    代码提交后触发自动化的单元测试，代码预编译，构建镜像，上传镜像等．
    cd(持续发布)
    持续发布则指将构建好的程序发布到各种环境，如预发布环境，正式环境．
```

> 官网： https://docs.gitlab.com/ee/ci/README.html

![](https://pan.layne666.cn/images/2021/12/02/eTEjQvEZXS.png)

# 特性

```text
gitlab ci/cd是由独立的runner程序完成，runner采用go语言编写，
因此可以很好的进行跨平台，通常可以将runner部署到任何gitlab server之外的服务器，从而避免对gitlab server的影响．
```

> 官网：https://docs.gitlab.com/runner/

![](https://pan.layne666.cn/images/2021/12/02/IJq0lYdfme.png)

# GitLab Runner安装

## 添加gitlab官方库

```powershell
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
```

## 安装Runner

```Powershell
sudo yum install gitlab-runner
```

## 把项目注册到到Runner

### 找到发布项目的注册信息

按 Settings -> CI / CD -> Runners 顺序找到`Set up a specific Runner manually`里的注册信息！

![](https://pan.layne666.cn/images/2021/12/02/VXArZHWA90.png)

![](https://pan.layne666.cn/images/2021/12/02/iODlyQLg5k.png)

![](https://pan.layne666.cn/images/2021/12/02/Ls6u9z2onm.png)

```Powershell
gitlab-runner register
```

根据提示内容输入对应的注册信息！如图所示：

![](https://pan.layne666.cn/images/2021/12/02/gSCLmUvVDc.png)

可以查看一下服务是否在运行，如果没有需手动启动！

```Powershell
systemctl status gitlab-runner
```

把nginx的html目录权限赋给`gitlab-runner`用户，不然编译后部署会报没有权限的错！

```Powershell
chown -R gitlab-runner /usr/local/nginx/html/
```

# 安装Hexo

> 需要先确保服务器的运行环境中已经安装了 NodeJS

执行全局安装`Hexo`的命令：

```Powershell
全局安装 Hexo
npm install hexo-cli -g
建立软链接
ln -s /usr/local/nodejs/bin/hexo /usr/local/bin/hexo
```

# 配置gitlab-ci.yml文件

具体配置如下：

```yml
image: node # 使用node 镜像

build:
  only:
    - master # 只有master更新的时候才执行命令
  script: # 执行的命令
    - npm install --registry https://registry.npm.taobao.org
    - hexo cl && hexo g
    - rm -rf /usr/local/nginx/html/*
    - cp -r public/* /usr/local/nginx/html/
  tags:
    - zfwfyblog
```

推送代码后，看对应的`job`任务是否有报错！

![](https://pan.layne666.cn/images/2021/12/02/ZbWWrDLbgl.png)

# FAQ

- 注册 gitlab-runner 时，提示报错：
`GitLab Runner >= 9.0 can be used ONLY with GitLab CE/EE >= 9.0`
这个因为默`gitlab runner安装时最新版的，与我们正在使用的 gitlab 版本不匹配，那么我们找到匹配的 gitlab-runner 版本安装即可，从这里我们可以找到  Runner 和 GitLab CE / EE 兼容性列表
- 有时 runner 会连接不上，或者在项目仓库 -> 设置 -> runner 里呈灰色，这有可能是 runner 机器上没有启动 gitlab-runner 引起的，可以执行`ps -ef | grep gitlab`看看是否存在 gitlab-runner 的进程，如果没有则执行 gitlab-runner start 命令启动`runner`服务。
- 若已经配置好了 gitlab-runner 了，执行 commit，pipeline 状态一直是`pending`，并且提示：
`This build is stuck, because the project doesn't have any runners online assigned to it. Go to Runners page`
这个是因为未找到对应的 runner 导致的，原因一是有可能 gitlab-runner 注册失败，原因二有可能是 .gitlab-ci.yml 配置文件里面`tags`没有匹配到已注册可用的 runner。