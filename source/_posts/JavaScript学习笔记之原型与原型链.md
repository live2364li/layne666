---
title: JavaScript学习笔记之原型与原型链
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/QBV8sewcSq.png
date: 2019-01-31 16:56:10
updated: 2019-02-08 17:20:19
categories: 
  - 前端
tags: 
  - JavaScript 
---

## 原型

1. 函数的prototype属性(如图)
  * 每个函数都有一个prototype属性, 它默认指向一个Object空对象(即称为: 原型对象)
  * 原型对象中有一个属性constructor, 它指向函数对象

![](https://pan.layne666.cn/images/2021/12/02/9CR8HPSedb.png)

2. 给原型对象添加属性(一般都是方法)
  * 作用: 函数的所有实例对象自动拥有原型中的属性(方法)

```JavaScript
<script type="text/javascript">

  // 每个函数都有一个prototype属性, 它默认指向一个Object空对象(即称为: 原型对象)
  console.log(Date.prototype, typeof Date.prototype);//Object "object"
  function Fun () { }
  console.log(Fun.prototype);  // 默认指向一个Object空对象(没有我们的属性)

  // 原型对象中有一个属性constructor, 它指向函数对象
  console.log(Date.prototype.constructor===Date); //true
  console.log(Fun.prototype.constructor===Fun); //true

  //给原型对象添加属性(一般是方法) ===>实例对象可以访问
  Fun.prototype.test = function () {
    console.log('test()');
  }
  var fun = new Fun();
  fun.test(); //test()
  
</script>
```

## 显式原型与隐式原型

1. 每个函数function都有一个`prototype`，即**显式原型(属性)**
2. 每个实例对象都有一个` __proto__`，可称为**隐式原型(属性)**
3. 对象的隐式原型的值为其对应构造函数的显式原型的值
4. 内存结构(如图)

![](https://pan.layne666.cn/images/2021/12/02/jsuZwta72r.png)

5. 总结:
  * 函数的prototype属性: **在定义函数时自动添加的, 默认值是一个空Object对象**
  * 对象的`__proto__`属性: **创建对象时自动添加的, 默认值为构造函数的prototype属性值**
  * 程序员能直接操作显式原型, 但不能直接操作隐式原型(ES6之前)

```JavaScript
<script type="text/javascript">

  //定义构造函数
  function Fn() {   // 内部语句: this.prototype = {}

  }
  // 1. 每个函数function都有一个prototype，即显式原型属性, 默认指向一个空的Object对象
  console.log(Fn.prototype);
  // 2. 每个实例对象都有一个__proto__，可称为隐式原型
  //创建实例对象
  var fn = new Fn(); // 内部语句: this.__proto__ = Fn.prototype
  console.log(fn.__proto__);
  // 3. 对象的隐式原型的值为其对应构造函数的显式原型的值
  console.log(Fn.prototype===fn.__proto__); // true
  //给原型添加方法
  Fn.prototype.test = function () {
    console.log('test()');
  }
  //通过实例调用原型的方法
  fn.test(); // test()
  
</script>
```

## 原型链

1. 原型链(图解)
  * 访问一个对象的属性时，
    * 先在自身属性中查找，找到返回
    * 如果没有, 再沿着`__proto__`这条链向上查找, 找到返回
    * 如果最终没找到, 返回undefined
  * 别名: 隐式原型链
  * 作用: **查找对象的属性(方法)**

![](https://pan.layne666.cn/images/2021/12/02/INoXaiNP6y.png)

2. 构造函数/原型/实体对象的关系(图解)

![](https://pan.layne666.cn/images/2021/12/02/KpXp5GYNK1.png)

3. 构造函数/原型/实体对象的关系2(图解)

![](https://pan.layne666.cn/images/2021/12/02/1netlHiyNa.png)
 
```JavaScript
<script type="text/javascript">
  // console.log(Object)
  // console.log(Object.prototype)
  console.log(Object.prototype.__proto__); // null
  function Fn() {
    this.test1 = function () {
      console.log('test1()');
    }
  }
  console.log(Fn.prototype);
  Fn.prototype.test2 = function () {
    console.log('test2()');
  }

  var fn = new Fn();
  fn.test1(); // test1()
  fn.test2(); // test2()
  console.log(fn.toString()); // [object Object]
  console.log(fn.test3); // undefined
  //fn.test3()  fn.test3 is not a function

  /*
  1. 函数的显示原型指向的对象默认是空Object实例对象(但Object不满足)
   */
  console.log(Fn.prototype instanceof Object); // true
  console.log(Object.prototype instanceof Object); // false
  console.log(Function.prototype instanceof Object); // true
  /*
  2. 所有函数都是Function的实例(包含Function)
  */
  console.log(Function.__proto__===Function.prototype); // true
  /*
  3. Object的原型对象是原型链尽头
   */
  console.log(Object.prototype.__proto__); // null

</script>
```

## 原型链_属性问题

1. 读取对象的属性值时: 会自动到原型链中查找
2. 设置对象的属性值时: 不会查找原型链, 如果当前对象中没有此属性, 直接添加此属性并设置其值
3. 方法一般定义在原型中, 属性一般通过构造函数定义在对象本身上

```JavaScript
<script type="text/javascript">

  function Fn() { }
  Fn.prototype.a = 'xxx';
  var fn1 = new Fn();
  console.log(fn1.a, fn1);// xxx,Fn

  var fn2 = new Fn();
  fn2.a = 'yyy';
  console.log(fn1.a, fn2.a, fn2);//xxx,yyy,Fn

  function Person(name, age) {
    this.name = name;
    this.age = age;
  }
  Person.prototype.setName = function (name) {
    this.name = name;
  }
  var p1 = new Person('Tom', 12);
  p1.setName('Bob');
  console.log(p1);//Person age: 12 name: "Bob" __proto__: Object

  var p2 = new Person('Jack', 12);
  p2.setName('Cat');
  console.log(p2);//Person age: 12 name: "Cat" __proto__: Object
  console.log(p1.__proto__===p2.__proto__); // true

</script>
```

## 探索instanceof

1. instanceof是如何判断的?
  * 表达式: A instanceof B
  * **如果B函数的显式原型对象在A对象的原型链上, 返回true, 否则返回false**
2. Function是通过new自己产生的实例

```JavaScript
<script type="text/javascript">
  //原型链图如下
  /*
  案例1 
   */
  function Foo() {  }
  var f1 = new Foo();
  console.log(f1 instanceof Foo); // true
  console.log(f1 instanceof Object); // true

  /*
  案例2
   */
  console.log(Object instanceof Function); // true
  console.log(Object instanceof Object); // true
  console.log(Function instanceof Function); // true
  console.log(Function instanceof Object); // true

  function Foo() {}
  console.log(Object instanceof  Foo); // false
</script>
```

![](https://pan.layne666.cn/images/2021/12/02/bIABgZswNH.png)
