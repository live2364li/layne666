---
title: JavaScript学习笔记之闭包
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/hlgWPeSNQl.jpg
date: 2019-02-07 23:50:29
updated: 2019-02-08 17:20:30
categories: 
  - 前端
tags: 
  - JavaScript
---

## 引入

我们先看一个栗子~
```html
<!--
  需求: 点击某个按钮, 提示"点击的是第n个按钮"
  -->
<button>测试1</button>
<button>测试2</button>
<button>测试3</button>
<script type="text/javascript">
  var btns = document.getElementsByTagName('button')
  //遍历加监听
  /*
  for (var i = 0,length=btns.length; i < length; i++) {
    var btn = btns[i]
    btn.onclick = function () {
      alert('第'+(i+1)+'个') //一直是第4个
    }
  }*/
  /*
  for (var i = 0,length=btns.length; i < length; i++) {
    var btn = btns[i]
    //将btn所对应的下标保存在btn上
    btn.index = i
    btn.onclick = function () {
      alert('第'+(this.index+1)+'个')//实现需求
    }
  }*/

  //利用闭包
  for (var i = 0,length=btns.length; i < length; i++) {
      (function (j) {
          var btn = btns[j]
          btn.onclick = function () {
              alert('第'+(j+1)+'个')//闭包实现需求
          }
      })(i)
  }
</script>
```

## 理解闭包

1\. 如何产生闭包?

* 当一个嵌套的内部(子)函数引用了嵌套的外部(父)函数的变量(函数)时, 就产生了闭包

2\. 闭包到底是什么?

* 使用chrome调试查看（Closure）

* 理解一: 闭包是嵌套的内部函数(绝大部分人)

* 理解二: 包含被引用变量(函数)的对象(极少数人)

* 注意: 闭包存在于嵌套的内部函数中

3\. 产生闭包的条件?

* 函数嵌套

* 内部函数引用了外部函数的数据(变量/函数)

## 常见的闭包

1\. 将函数作为另一个函数的返回值
```JavaScript
// 1. 将函数作为另一个函数的返回值
function fn1() {
    var a = 2
    function fn2() {
        a++
        console.log(a)
    }
    return fn2
}
var f = fn1()
f() // 3
f() // 4
```
2\. 将函数作为实参传递给另一个函数调用
```JavaScript
// 2. 将函数作为实参传递给另一个函数调用
function showDelay(msg, time) {
    setTimeout(function () {
        alert(msg)
    }, time)
}
showDelay('something', 2000)
```

## 闭包的作用

1. 使用函数内部的变量在函数执行完后, 仍然存活在内存中(延长了局部变量的生命周期)

2. 让函数外部可以操作(读写)到函数内部的数据(变量/函数)

问题:

1. 函数执行完后, 函数内部声明的局部变量是否还存在?
   一般是不存在, 存在于闭中的变量才可能存在

2. 在函数外部能直接访问函数内部的局部变量吗? 
   不能, 但我们可以通过闭包让外部操作它

## 闭包的生命周期

1\. 产生: 在嵌套内部函数定义执行完时就产生了(不是在调用)

2\. 死亡: 在嵌套的内部函数成为垃圾对象时

```JavaScript
function fn1() {
    //此时闭包就已经产生了(函数提升, 内部函数对象已经创建了)
    var a = 2
    function fn2 () {
        a++
        console.log(a)
    }
    return fn2
}
var f = fn1()
f() // 3
f() // 4
f = null //闭包死亡(包含闭包的函数对象成为垃圾对象),手动置为null，让垃圾回收器回收
```

## 闭包的缺点及解决
1\. 缺点

* 函数执行完后, 函数内的局部变量没有释放, 占用内存时间会变长

* 容易造成内存泄露

2\. 解决

* 能不用闭包就不用

* 及时释放

```JavaScript
function fn1() {
    var arr = new Array[100000]
    function fn2() {
        console.log(arr.length)
    }
    return fn2
}
var f = fn1()
f()
f = null //让内部函数成为垃圾对象-->回收闭包
```