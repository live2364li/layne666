---
title: merge和rebase的区别
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/mtfhJZgxkj.png
date: 2019-03-13 23:00:13
updated: 2019-03-13 23:00:13
categories: 
  - Git
tags: 
  - Git
---

用 `Git` 进行多人协作开发时，必然会合并代码，解决冲突。然而合并代码也是需要点技巧的，如果对一些关键命令没有理解去使用的话，git 的版本演进路线就会变得很乱，从而造成了日后维护的一些麻烦。

Git 上合并代码有 `git merge` 以及 `git rebase` 两种方式。下面将深入两者的用法以及对两者的适用场景作个总结。

## 场景

现在在 develop 开发分支上，然后你创建了一个 feature 分支开发新功能，现在团队中另一个成员在 develop 分支上添加了新的提交。如下图所示：

![](https://pan.layne666.cn/images/2021/12/02/1qqZhD11WW.png)

现在，如果 develop 中新的提交和你的工作是相关的。为了将新的提交并入你的分支，你有两个选择：merge 或 rebase。

## merge

### git merge

执行以下命令：

```bash
git checkout feature
git merge develop
或者执行：
git merge develop feature
```

feature 分支中新的合并提交 (merge commit) 将两个分支的历史连在了一起。你会得到下面这样的分支结构：

![](https://pan.layne666.cn/images/2021/12/02/w88smkL1Nn.png)

merge 特点
1. 自动创建一个新的 commit
2. 当合并时遇到冲突，修改后重新 commit 即可

**优点**：将 commit 的实际情况进行记录，便于以后查看

**缺点**：由于每次 merge 会自动产生一个 merge commit，所以在使用一些 git 的 GUI tools，如果 commit 频繁，这样会使得 feature 分支很杂乱，这时可以考虑使用 rebase 来进行合并处理。

### git merge - -no-ff

执行以下命令：

```bash
git checkout feature
git merge --no-ff develop
```

默认情况下，Git 执行`快进式合并`（fast-farward merge），会直接将 develop 分支指向 feature 分支。如 git merge 里的图所示。使用 `- -no-ff` 参数后，会执行正常合并，在 develop 分支上生成一个新节点。

### 两者区别

* git merge - -no-ff 可以保存你之前的分支历史。能够更好的查看 merge 历史，以及 branch 状态。
* git merge 则不会显示 feature，只保留单条分支记录。

来一张分解图示例：

![](https://pan.layne666.cn/images/2021/12/02/ron492R7SX.png)

## rebase

### git rebase

本质是变基，即找公共祖先
执行以下命令：

```bash
git checkout feature
git rebase develop
```

![](https://pan.layne666.cn/images/2021/12/02/bI9ouZljBY.png)

它会把整个 feature 分支移动到 develop 分支的后面，有效地把所有 develop 分支上新的提交并入过来。但是，rebase 为原分支上每一个提交创建一个新的提交，重写了项目历史，并且不会带来合并提交。

### rebase 特点

将 commit 历史进行合并

**优点**：项目历史比较简单，少了 merge commit

**缺点**：当发生冲突时不容易定位问题，因为重写了历史记录

### 合并时出现冲突按如下步骤解决

1. 修改冲突部分
2. git add
3. git rebase --continue

（如果第三步无效可以执行 git rebase --skip）
**不要在 git add 之后习惯性的执行 git commit 命令**

### rebase 的黄金法则

```java
never use it on public branches(不要在公共分支上使用)
```

比如说，如果你在 develop 分支上，rebase 到你的 feature 分支上会发生什么？

![](https://pan.layne666.cn/images/2021/12/02/pg8NUrCJdR.png)

rebase 将所有 develop 的 commit 移动到你的 feature 的顶端。问题是：其他人还在 develop 上开发，由于你使用了rebase 移动了 develop，git 会认为你的主分支的历史与其他人的有分歧，会产生冲突。

所以在执行 git rebase 之前需要认真考虑，`绝不要在公共的分支上使用它`。在你运行 git rebase 之前，一定要问问你自己“有没有别人正在这个分支上工作？”。如果答案是肯定的，重新找到一个无害的方式（如`git revert`）来提交你的更改。不然的话，你可以随心所欲地重写历史。

## 总结

如果你想要一个干净的、线性的提交历史，没有不必要的合并提交，你应该使用`git rebase`而不是`git merge`来并入其他分支上的更改。

另一方面，如果你想要保存项目完整的历史，并且避免重写公共分支上的 commit，你可以使用`git merge (--no-ff)`。