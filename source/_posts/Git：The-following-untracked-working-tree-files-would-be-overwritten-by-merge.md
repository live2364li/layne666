---
title: Git：The following untracked working tree files would be overwritten by merge
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/gtyoi7MdK1.jpg
date: 2019-02-19 10:40:48
updated: 2019-02-19 10:43:27
categories: 
  - Git
tags: 
  - Git
---

## 问题

```bash
The following untracked working tree files would be overwritten by merge
```

## 解决方案

```bash
git clean -d -fx
```

## 延伸阅读

```bash
$ git clean -f -n         # 1
$ git clean -f            # 2
$ git clean -fd           # 3
$ git clean -fX           # 4
$ git clean -fx           # 5

(1): 选项-n将显示执行（2）时将会移除哪些文件。
(2): 该命令会移除所有命令（1）中显示的文件。
(3): 如果你还想移除文件件，请使用选项-d。
(4): 如果你只想移除已被忽略的文件，请使用选项-X。
(5): 如果你想移除已被忽略和未被忽略的文件，请使用选项-x。
```