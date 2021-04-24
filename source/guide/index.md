---
title: 写作指南与规范
date: 2020-09-01 19:23:29
updated: 2020-09-01 19:23:29
aplayer: true
aside: false
---

## 快速开始

是不是克隆了代码到本地之后不知道该怎么办？现在就开始快速开始吧！

> 本地需要先安装一下NodeJS，便于本地编译运行调试！

### 安装 Hexo

本网站由 [Hexo](https://hexo.io/zh-cn/) 驱动，所以请确保你的运行环境中已经安装了 `NodeJS`。下面是全局安装 `Hexo` 的命令：

```
npm install hexo-cli -g
```

### 克隆代码

```
# 克隆代码到本地.
git clone http://open.thunisoft.com/liuwei-2/zfwfyblog.git
```

### 安装依赖

克隆了代码之后，第一次运行需要安装所需要的相关依赖。进入 `zfwfyblog` 的根目录中，执行：

```
cd zfwfyblog

# 执行此命令安装依赖
npm install --registry https://registry.npm.taobao.org
```

### 编译运行

安装完依赖之后，接下来就可以直接启动运行本站点了，执行如下命令即可：

```
hexo cl && hexo g && hexo s
```

当你在终端中看到如下信息时就表明已经启动成功了，可以在本地直接访问 http://localhost:4000/ 看效果。

```
INFO  Start processing
INFO  Hexo is running at http://localhost:4000 .
```

## 写作

你是不是不知道该怎么写文章？别慌，很简单！

### 创建文章

你可以执行下列命令来创建一篇新文章，也可以直接复制`Markdown` 文件到 `source/_post` 文件对应的分类目录中，然后添加该文章对应的 `Post Front-matter` 即可。

```
hexo new title
```

> md 文件名最终会被编译为跳转地址，所以尽量短一些。而文章属性里的 title 属性，是指页面展示的标题名，这按你原来的命名即可。

### Post Front-matter

文章的全部属性如下：

```
--- 
title: 
date: 
updated: 
tags: 
categories: 
keywords: 
description: 
top _img: 
comments：
cover:   
toc:   
toc_ number: 
auto _open: 
copyright: 
copyright_ author: 
copyright _author_ href: 
copyright _url: 
copyright_ info: 
mathjax: 
katex : 
aplayer：
highlight _shrink：
---
```

| 写法                  | 解释                                                         |
| --------------------- | ------------------------------------------------------------ |
| title                 | 【必需】文章标题                                             |
| date                  | 【必需】文章创建日期                                         |
| updated               | 【可选】文章更新日期                                         |
| tags                  | 【可选】文章标签                                             |
| categories            | 【可选】文章分类                                             |
| keywords              | 【可选】文章关键字                                           |
| description           | 【可选】文章描述                                             |
| top_img               | 【可选】文章顶部图片                                         |
| cover                 | 【可选】文章缩略图(如果没有设置top_img, 文章页顶部将显示缩略图，可设为false / 图片地址/ 留空) |
| comments              | 【可选】显示文章评论模块(默认true)                           |
| toc                   | 【可选】显示文章TOC (默认为设置中toc 的enable 配置)          |
| toc_number            | 【可选】显示toc_number (默认为设置中toc 的number 配置)       |
| auto_open             | 【可选】是否自动打开TOC (默认为设置中toc 的auto_open 配置)   |
| copyright             | 【可选】显示文章版权模块(默认为设置中post_copyright 的enable 配置) |
| copyright_author      | 【可选】文章版权模块的文章作者                               |
| copyright_author_href | 【可选】文章版权模块的文章作者链接                           |
| copyright_url         | 【可选】文章版权模块的文章連結链接                           |
| copyright_info        | 【可选】文章版权模块的版權聲明文字                           |
| mathjax               | 【可选】显示mathjax (当设置mathjax 的per_page: false 时，才需要配置，默认false) |
| katex                 | 【可选】显示katex (当设置katex 的per_page: false 时，才需要配置，默认false) |
| aplayer               | 【可选】在需要的页面加载aplayer的js和css,请参考文章下面的音樂配置 |
| highlight_shrink      | 【可选】配置代码框是否展开(true/false)(默认为设置中highlight_shrink 的配置) |

### 创建页面

上述只是创建文章，那该怎么创建对应的页面呢？如标签页面、音乐页面、图库页面等等。

你可以执行下列命令来创建一个新页面，也可以在`source` 目录下新建个文件夹，然后直接复制`Markdown`文件到 到该文件夹下并且重命名为`index.md`，然后添加对应的 `Page Front-matter` 即可。

### Page Front-matter

```
--- 
title: 
date: 
updated: 
type: 
comments: 
description: 
keywords: 
top _img: 
mathjax: 
katex: 
aside: 
aplayer：
highlight_ shrink：
---
```

| 写法             | 解释                                                         |
| :--------------- | :----------------------------------------------------------- |
| title            | 【必需】页面标题                                             |
| date             | 【必需】页面创建日期                                         |
| type             | 【必需】标签、分类和友情链接三个页面需要配置                 |
| updated          | 【可选】页面更新日期                                         |
| description      | 【可选】页面描述                                             |
| keywords         | 【可选】页面关键字                                           |
| comments         | 【可选】显示页面评论模块(默认true)                           |
| top_img          | 【可选】页面顶部图片                                         |
| mathjax          | 【可选】显示mathjax (当设置mathjax 的per_page: false 时，才需要配置，默认false) |
| katex            | 【可选】显示katex (当设置katex 的per_page: false 时，才需要配置，默认false) |
| aside            | 【可选】显示侧边栏(默认true)                                 |
| aplayer          | 【可选】在需要的页面加载aplayer的js和css                     |
| highlight_shrink | 【可选】配置代码框是否展开(true/false)(默认为设置中highlight_shrink 的配置) |

### 写作要求

每个人在投稿自己的文章时，在`_post`目录下，都需要先建一个文件夹，名字为你自己名字的小写，这样便于大家后期好维护自己的文章。

文章的分类、标签、创建日期、更新日期、标题、作者这几个都要写上。另外，注意一下文章的标题大小格式，要用`h1h2h3`或者`h2h3h4`循环渐进，如果用`h1h3h4`这种的话，生成的`TOC`目录会很难看！

最后，如果可以的话，最好给文章加一个封面图（`cover`属性），这样岂不是很好看？

## 图片

文章难免会有一些图片需要引入，那该怎么引入呢？

### 华宇图床

可以先把图片上传到 [华宇图床](http://bed.thunisoft.com/)，然后在文章引用外链即可，好处是很方便，坏处是挂了你图片可能就找不到了（一般来说不会挂吧）。

> 还有上传小工具哦！

### 项目托管

如果你不想用图床，也可以把图片放在`source/images`目录下，但需要注意的是，也要先建一个自己名字小写的文件夹，然后把图片存进去并且在文章中引用，这样每个人就只需要维护自己的文件夹即可。

> 好处是不会丢失，坏处是有点麻烦。

### 其他

当然图床也有很多，比如七牛云，阿里云等等自己搭建的图床，也是可以的，看你自己选择！

## 总结

目前该项目已配置`CI-CD`，实现了代码推送后的自动编译与部署，更方便大家写作了！

不多说，干就完了！