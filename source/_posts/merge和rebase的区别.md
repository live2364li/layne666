---
title: merge和rebase的区别
date: '2019-03-13 23:00:13'
updated: '2019-03-13 23:00:13'
tags: [Git]
categories: Git
---
用Git进行多人协作开发时，必然会合并代码，解决冲突。然而合并代码也是需要点技巧的，如果对一些关键命令没有理解去使用的话，git的版本演进路线就会变得很乱，从而造成了日后维护的一些麻烦。

Git上合并代码有git merge 以及 git rebase 两种方式。下面将深入两者的用法以及对两者的适用场景作个总结。<!--more-->

## 场景

现在在develop开发分支上，然后你创建了一个feature分支开发新功能，现在团队中另一个成员在develop分支上添加了新的提交。如下图所示：

![](../images/merge和rebase的区别/1.png)

现在，如果develop中新的提交和你的工作是相关的。为了将新的提交并入你的分支，你有两个选择：merge或rebase。

## merge

### git merge

执行以下命令：

```bash
git checkout feature
git merge develop
或者执行：
git merge develop feature
```

feature分支中新的合并提交(merge commit)将两个分支的历史连在了一起。你会得到下面这样的分支结构：

![](../images/merge和rebase的区别/2.png)

merge 特点
1. 自动创建一个新的commit
2. 当合并时遇到冲突，修改后重新commit即可

**优点**：将commit的实际情况进行记录，便于以后查看

**缺点**：由于每次merge会自动产生一个merge commit，所以在使用一些git 的GUI tools，如果commit频繁，这样会使得feature分支很杂乱，这时可以考虑使用rebase来进行合并处理。

### git merge - -no-ff

执行以下命令：

```bash
git checkout feature
git merge --no-ff develop
```

默认情况下，Git执行"快进式合并"（fast-farward merge），会直接将develop分支指向feature分支。如git merge里的图所示。使用- -no-ff参数后，会执行正常合并，在develop分支上生成一个新节点。

### 两者区别

* git merge - -no-ff 可以保存你之前的分支历史。能够更好的查看 merge历史，以及branch 状态。
* git merge 则不会显示 feature，只保留单条分支记录。

来一张分解图示例：

![](../images/merge和rebase的区别/3.png)

## rebase

### git rebase

本质是变基，即找公共祖先
执行以下命令：

```bash
git checkout feature
git rebase develop
```

![](../images/merge和rebase的区别/4.png)

它会把整个feature分支移动到develop分支的后面，有效地把所有develop分支上新的提交并入过来。但是，rebase为原分支上每一个提交创建一个新的提交，重写了项目历史，并且不会带来合并提交。

### rebase 特点

将commit历史进行合并

**优点**：项目历史比较简单，少了merge commit

**缺点**：当发生冲突时不容易定位问题，因为重写了历史记录

### 合并时出现冲突按如下步骤解决

1. 修改冲突部分
2. git add
3. git rebase --continue

（如果第三步无效可以执行 git rebase --skip）
**不要在git add 之后习惯性的执行 git commit命令**

### rebase 的黄金法则

```java
never use it on public branches(不要在公共分支上使用)
```

比如说，如果你在develop分支上，rebase到你的feature分支上会发生什么？

![](../images/merge和rebase的区别/5.png)

rebase将所有develop的commit移动到你的feature的顶端。问题是：其他人还在develop上开发，由于你使用了rebase移动了develop，git会认为你的主分支的历史与其他人的有分歧，会产生冲突。

所以在执行git rebase之前需要认真考虑，`绝不要在公共的分支上使用它`。在你运行git rebase 之前，一定要问问你自己“有没有别人正在这个分支上工作？”。如果答案是肯定的，重新找到一个无害的方式（如`git revert`）来提交你的更改。不然的话，你可以随心所欲地重写历史。

## 总结

如果你想要一个干净的、线性的提交历史，没有不必要的合并提交，你应该使用`git rebase`而不是`git merge`来并入其他分支上的更改。

另一方面，如果你想要保存项目完整的历史，并且避免重写公共分支上的commit，你可以使用`git merge (--no-ff)`。