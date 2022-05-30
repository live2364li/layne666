---
title: Git Push 常见用法整理
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/Wo7t82uset.jpg
date: 2019-08-13 23:35:37
updated: 2019-08-13 23:35:37
categories: 
  - Git
tags: 
  - Git
---

git push的一般形式为 git push <远程主机名> <本地分支名>:<远程分支名> 

例如 `git push origin master:master` ，即是将本地的 master 分支推送到远程主机 origin 上的对应 master 分支， origin 是远程主机名，

第一个 master 是本地分支名，第二个 master 是远程分支名。

## git push origin master

如果远程分支被省略，如上则表示将本地分支推送到与之存在追踪关系的远程分支（通常两者同名），如果该远程分支不存在，则会被新建

## git push origin :master 

如果省略本地分支名，则`表示删除指定的远程分支`，因为这等同于推送一个空的本地分支到远程分支，等同于 git push origin --delete master

## git push origin

如果`当前分支与远程分支存在追踪关系`，则本地分支和远程分支都可以省略，将当前分支推送到origin主机的对应分支 

## git push

如果当前分支只有一个远程分支，那么主机名都可以省略，形如 git push，可以使用 `git branch -r` ，查看远程的分支名

## git push 的其他命令

这几个常见的用法已足以满足我们日常开发的使用了，还有几个扩展的用法，如下：

### git push -u origin master 

如果当前分支与多个主机存在追踪关系，则可以使用 `-u` 参数指定一个默认主机，这样后面就可以不加任何参数使用 git push

### git push --all origin

当遇到这种情况就是不管是否存在对应的远程分支，将本地的所有分支都推送到远程主机，这时需要 `-all` 选项

### git push --force origin 

git push 的时候需要本地先 `git pull` 更新到跟服务器版本一致，如果本地版本库比远程服务器上的低，那么一般会提示你git pull更新，如果一定要提交，那么可以使用这个命令。

### git push origin --tags 

git push 的时候不会推送分支，如果一定要推送标签的话那么可以使用这个命令

## 关于 refs/for

`refs/for` 的意义在于我们提交代码到服务器之后是需要经过 code review 之后才能进行 merge 的，而 `refs/heads` 不需要

**举例**：如果需要 code review，直接执行 push：

```shell
$ git push origin mybranch
```

就会报错“! [remote rejected] master -> master (prohibited by Gerrit)”必须用以下语句：

```shell
$ git push origin HEAD:resf/for/mybranch
```