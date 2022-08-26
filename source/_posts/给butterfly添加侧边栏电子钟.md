---
abbrlink: ''
categories: []
date: '2022-08-26 20:37:08'
tags: []
title: 给butterfly添加侧边栏电子钟
updated: '2022-08-26 20:37:18'
---点击查看参考教材
基于店长方案进行修改

参考方向	教程原贴
店长原教程	给hexo-theme-butterfly添加 侧边栏电子钟

如果有安装店长的插件版侧边栏电子钟（与店长的电子钟冲突），在博客根目录[Blogroot]下打开终端，运行以下指令

BASH
1
2

# 卸载原版电子钟

npm uninstall hexo-butterfly-clock
安装插件,在博客根目录[Blogroot]下打开终端，运行以下指令：

BASH
1
npm install hexo-butterfly-clock-anzhiyu --save
添加配置信息，以下为写法示例
在站点配置文件_config.yml或者主题配置文件_config.butterfly.yml中添加

# electric_clock

# see https://anzhiy.cn/posts/fc18.html

electric_clock:
enable: true # 开关
priority: 5 #过滤器优先权
enable_page: all # 应用页面
exclude:
# - /posts/
# - /about/
layout: # 挂载容器类型
type: class
name: sticky_layout
index: 0
loading: https://cdn.cbd.int/hexo-butterfly-clock-anzhiyu@1.0.5/lib/loading.gif #加载动画自定义
clock_css: https://cdn.cbd.int/hexo-butterfly-clock-anzhiyu@1.0.5/lib/clock.min.css
clock_js: https://cdn.cbd.int/hexo-butterfly-clock-anzhiyu@1.0.5/lib/clock.min.js
ip_api: https://widget.qweather.net/simple/static/js/he-simple-common.js?v=2.0
qweather_key:  # 和风天气key
gaud_map_key:  # 高得地图web服务key
其中qweather_key 和gaud_map_key 最好自己去申请对应的api key，默认使用我自己的，可能会被限制，不保证可靠性

点击查看参考教程
qweather_key申请地址: https://id.qweather.com/#/login

登录后进入控制台

创建应用

填写应用名称和key名称随意
选择WebApi

复制key

gaud_map_key 申请地址: https://lbs.amap.com/

登录后进入控制台
创建应用，名称随意，类型选其他

点击添加, key名称随意，服务平台选择Web服务,点击提交

复制key

参数释义
参数	备选值/类型	释义
priority	number	【可选】过滤器优先级，数值越小，执行越早，默认为10，选填
enable	true/false	【必选】控制开关
enable_page	path/all	【可选】填写想要应用的页面的相对路径（即路由地址）,如根目录就填’/‘,分类页面就填’/categories/‘。若要应用于所有页面，就填’all’，默认为all
exclude	path	【可选】填写想要屏蔽的页面，可以多个。写法见示例。原理是将屏蔽项的内容逐个放到当前路径去匹配，若当前路径包含任一屏蔽项，则不会挂载。
layout.type	id/class	【可选】挂载容器类型，填写id或class，不填则默认为id
layout.name	text	【必选】挂载容器名称
layout.index	0和正整数	【可选】前提是layout.type为class，因为同一页面可能有多个class，此项用来确认究竟排在第几个顺位
loading	URL	【可选】电子钟加载动画的图片
clock_css	URL	【可选】电子钟样式CDN资源
clock_js	URL	【可选】电子钟执行脚本CDN资源
ip_api	URL	【可选】获取时钟IP的API
qweather_key	text	【可选】和风天气key
gaud_map_key	text	【可选】高得地图web服务key
参考方向	教程原贴
店长原教程	给hexo-theme-butterfly添加 侧边栏电子钟
