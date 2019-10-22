# layne666.cn

<a title="Travis CI" target="_blank" href="https://travis-ci.org/Layne666/layne666.cn"><img src="https://img.shields.io/travis/Layne666/layne666.cn"></a> <a title="layne666.cn" target="_blank" href="https://github.com/Layne666/layne666.cn"><img src="https://img.shields.io/github/repo-size/Layne666/layne666.cn"></a> <a title="最后一次提交" target="_blank" href="https://github.com/Layne666/layne666.site/commits/master"><img src="https://img.shields.io/github/last-commit/layne666/layne666.cn"></a>

> My lovely blog, the theme styles are modified and added based on [Hexo-theme-sagiri](https://github.com/DIYgod/hexo-theme-sagiri)

## 1. Hexo常用命令

```bash
hexo new"postName" #新建文章
hexo new page"pageName" #新建页面
hexo generate #生成静态页面至public目录
hexo server #开启预览访问端口（默认端口4000，'ctrl + c'关闭server）
hexo deploy #将.deploy目录部署到指定空间
hexo help # 查看帮助
hexo version #查看Hexo的版本
```

## 2. 修改文章内链接文本样式

打开文件 `themes/next/source/css/_common/components/post/post.styl`，在末尾添加

```css
.post-body p a {
  color: #0593d3;
  border-bottom: none;
  &:hover {
    color: #fc6423;
    border-bottom: none;
  }
}
```

其中选择 .post-body 是为了不影响标题，选择 p 是为了不影响首页“阅读全文”的显示样式,颜色可以自己定义。

## 3. Aplayer配置

```js
{% raw %}
<div class="aplayer" id="aplayer-blog-begin"></div>
<script>
$(function () {
    $.ajax({
        url: 'https://api.i-meto.com/meting/api?server=netease&type=song&id=573747359',
        success: function (list) {
            var ap = new APlayer({
                element: document.getElementById'aplayer-blog-begin'),
                showlrc: 3,
                volume: 0.5,
                theme: '#ad7a86',
                mode: 'random',
                music: JSON.parse(list)[0]
            });
            window.aplayers || (window.aplayers = []);
            window.aplayers.push(ap);
        }
    })
})
</script>
{% endraw %}
&nbsp;
```

## 4. 关闭页面评论

comments: false

## 5. 文章主页查看部分文章内容

在文章中加上`<!--more-->` 标记,首页文章只显示一部分

## 6. Dplayer配置

```js
{% raw %}
<script src="https://cdn.jsdelivr.net/npm/hls.js/dist/hls.min.js"></script>
<div class="dplayer" id="dplayer-yl"></div>
<script>
$(function () {
    var dp = new DPlayer({
        container: document.getElementById('dplayer-yl'),
        preload: 'metadata',
        mutex: false,
        video:{
           url: 'https://raw.githubusercontent.com/Layne666/imgRepo/master/video/siyue.mp4',
           pic: '/images/siyue.jpg'
        }
    });
    window.dplayers || (window.dplayers = []);
    window.dplayers.push(dp);
});
</script>
{% endraw %}
&nbsp;
```

## 7. 文章置顶

修改Hexo文件夹下的`node_modules/hexo-generator-index/lib/generator.js`，在生成文章之前进行文章top值排序。

以下是最终的generator.js内容：

```js
'use strict';

var pagination = require('hexo-pagination');

module.exports = function(locals) {
  var config = this.config;
  var posts = locals.posts.sort(config.index_generator.order_by);

  posts.data = posts.data.sort(function(a, b) {
      if(a.top && b.top) {
          if(a.top == b.top) return b.date - a.date;
          else return b.top - a.top;
      }
      else if(a.top && !b.top) {
          return -1;
      }
      else if(!a.top && b.top) {
          return 1;
      }
      else return b.date - a.date;
  });

  var paginationDir = config.pagination_dir || 'page';

  return pagination('', posts, {
    perPage: config.index_generator.per_page,
    layout: ['index', 'archive'],
    format: paginationDir + '/%d/',
    data: {
      __index: true
    }
  });
};
```

## 8. 设置置顶标志

打开：`/blog/themes/next/layout/_macro` 目录下的`post.swig`文件，定位到`<div class="post-meta">`标签下，插入如下代码：

```html
{% if post.top %}
    <i class="fa fa-thumb-tack"></i>
    <font color=7D26CD>置顶</font>
    <span class="post-meta-divider">|</span>
{% endif %}
```

---

参考资料：<br/>
https://www.jianshu.com/u/0cf965162867

https://www.jianshu.com/p/1ba96f9a339b

https://www.jianshu.com/p/efbeddc5eb19

https://www.jianshu.com/p/9f0e90cc32c2