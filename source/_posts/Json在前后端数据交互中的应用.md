---
title: JSON在前后端数据交互中的应用
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/HyvBNKKCIa.png
date: 2019-01-25 00:43:20
updated: 2019-02-08 17:20:13
categories: 
  - JSON
tags: 
  - JSON
---

## 什么是JSON？

JSON本来是javascript里的内容，有时后端要传各种各样的数据格式来适应前端，所以需要用到JSON来转换，用它来表示各种各样复杂的数据，如对象，数组，集合，以及集合的集合等数据。 

先来了解JSON是什么，`JSON是一种轻量级的前端后端以及网络传输的数据交换格式`，就是一串字符串，只不过元素会使用特定的符号标注。 {} 双括号表示对象，[] 中括号表示数组，”” 双引号内是属性或值，: 冒号表示后者是前者的值(这个值可以是字符串、数字、也可以是另一个数组或对象)。也就是说在后端可以把一个字符串，然后通过JSON来转换成特定的字符串传到前端去。

## JSON的用途

* 使用基于JavaScript的应用程序，其中包括浏览器扩展和网站
* 使用JSON格式序列化和结构化的数据传输网络连接
* 这主要用于服务器和Web应用程序之间的数据传输
* Web服务和API采用JSON格式提供公共数据
* 它可以用来与现代编程语言

## JSON的特点

* 易于读写JSON
* 轻量级的基于文本的交换格式
* 独立语言

## 一些常见的JSON格式

* 一个JSON对象——JSONObject

```JavaScript
简单点的：
var json = {"name":"张三", "age":18 };

复杂一点的：
var json = {"name":"张三", "age"=18，"address":{"city":南京","country":"中国"}}；
```

*  一个JSON数组——JSONArray

```JavaScript
简单点的：
var json = [{"name":"张三", "age":18 },{"name":"李四" , "age":20 }];

复杂一点的：
var json = [
  {"name":"张三", "age"=18, "address":{"city":"南京","country":"中国"}},

  {"name":"李四", "age"=20, "address":{"city":"苏州","country":"中国"}}
]
```

* 还有一种结构

```JavaScript
var json = {"abc":[{"name":"txt1"},{"name","txt2"}]};
//这里的json.abc是一个数组，数组是由2个子json组成的
```

## JSON在前端的应用

后端将数据处理成json格式，前端就通过ajax来接收数据，并eval()或者json.prase(data)解析，循环遍历，展现在页面上。

## 解析数据

* json字符串转换成json对象

```JavaScript
var obj = eval('(' + data + ')'); 或者 var obj = JSON.parse(data);
```

<font color=#FF0000>区别：eval方法不会去检查给的字符串时候符合json的格式，同时如果给的字符串中存在js代码eval也会一并执行。相比而言eval()不安全，建议用JSON.parse。</font>

* json对象转为json字符串

```JavaScript
var data = JSON.stringify(jsonObj);
```

在用Jquery进行ajax请求时，contentType:"application/json; charset=utf-8" 要求data必须是json字符串，dataType:“json”要求服务器返回的是json数据

### JSON.stringify()方法的三个参数

```JavaScript
var xiaoming = {
    name: '小明',
    age: 14,
    gender: true,
    height: 1.65,
    grade: null,
    'middle-school': '\"W3C\" Middle School',
    skills: ['JavaScript', 'Java', 'Python', 'Lisp']
};
```

运行如下：

```JavaScript
var s = JSON.stringify(xiaoming);
console.log(s);
结果：
{"name":"小明","age":14,"gender":true,"height":1.65,"grade":null,"middle-school":"\"W3C\" Middle School","skills":["JavaScript","Java","Python","Lisp"]}
```

第二个参数用于控制如何筛选对象的键值，如果我们只想输出指定的属性，可以传入`Array`：

```JavaScript
JSON.stringify(xiaoming, ['name', 'skills'], '  ');
```

结果如下：

```JavaScript
{
  "name": "小明",
  "skills": [
    "JavaScript",
    "Java",
    "Python",
    "Lisp"
  ]
}
```

还可以传入一个函数，这样对象的每个键值对都会被函数先处理：

```JavaScript
function convert(key, value) {
    if (typeof value === 'string') {
        return value.toUpperCase();
    }
    return value;
}

JSON.stringify(xiaoming, convert, '  ');

```

上面的代码把所有属性值都变成大写：

```JavaScript
{
  "name": "小明",
  "age": 14,
  "gender": true,
  "height": 1.65,
  "grade": null,
  "middle-school": "\"W3C\" MIDDLE SCHOOL",
  "skills": [
    "JAVASCRIPT",
    "JAVA",
    "PYTHON",
    "LISP"
  ]
}
```

第三参数`space`用来控制结果字符串里面的间距。如果是一个数字, 则在字符串化时每一级别会**比上一级别缩进多**这个数字值的空格（最多10个空格）；如果是一个字符串，则每一级别会比上一级别多缩进用该字符串（或该字符串的前十个字符）。

```JavaScript
JSON.stringify(data,null,10);
//每一个层级比上一个多10个空格
"{
          "name": "niuzai",
          "info": {
                    "age": 18,
                    "sex": "male"
          }
}"

JSON.stringify(data,null,'\t');
//每一个层级比上一个多一个制表符
"{
  "name": "niuzai",
  "info": {
    "age": 18,
    "sex": "male"
  }
}"
```

如果我们还想要精确控制如何序列化小明，可以给`xiaoming`定义一个`toJSON()`的方法，直接返回JSON应该序列化的数据：

```JavaScript
var xiaoming = {
    name: '小明',
    age: 14,
    gender: true,
    height: 1.65,
    grade: null,
    'middle-school': '\"W3C\" Middle School',
    skills: ['JavaScript', 'Java', 'Python', 'Lisp'],
    toJSON: function () {
        return { // 只输出name和age，并且改变了key：
            'Name': this.name,
            'Age': this.age
        };
    }
};

JSON.stringify(xiaoming); // '{"Name":"小明","Age":14}'
```

### 前端相关测试代码

```JavaScript
  //1.json字符串
  var user='{"userId":"11","username":"Tom","userAge":"18","password":"123456"}';
  //输出的都是undefined，不知道类型
  console.log(user.userId+" "+user.username);//undefined undefined
  //将json文本格式数据解析为json对象
  //var userObj=eval("("+ user+")");
  var userObj = JSON.parse(user);
  console.log(userObj.userId+" "+userObj.username);//11 Tom

  //2.json数组对象
  var emps={"employees":[
	  {"empId":"1","empName":"Tom"},
	  {"empId":"2","empName":"Lilei"},
	  {"empId":"3","empName":"Lucy"},
	  {"empId":"4","empName":"Lili"},
	  {"empId":"5","empName":"Hanmeimei"},
  ]};
  console.log(emps.employees[0].empId+"---"+emps.employees[0].empName);//1---Tom

  var emp='{"id":"1001","empName":"Lucy","hobbit":["eat","study"]}';//eat study
  //var empObj=eval("("+ emp +")"); 
  var empObj = JSON.parse(emp);
  console.log(empObj.hobbit[0]+" "+empObj.hobbit[1]);//
```

## JSON在后端的应用

### 使用JSONObject生成和解析JSON

首先在pom文件配置需要的jar
这里以2.4version为例

```xml
  <dependency>
	  <groupId>net.sf.json-lib</groupId>
	  <artifactId>json-lib</artifactId>
	  <version>2.4</version>
	  <classifier>jdk15</classifier>
  </dependency>
```

引入类之后相关代码如下：

```java
  //json字符串转java代码
  String jsonStr = "{\"password\":\"123456\",\"username\":\"张三\"}";
  JSONObject jsonObject = JSONObject.fromObject(jsonStr);
  String username = jsonObject.getString("username");
  String password = jsonObject.getString("password");
  System.err.println("json--->java \n username="+username+"\t passwor="+password);
  
  //java代码封装为json字符串
  JSONObject jsonObject = new JSONObject();
  jsonObject.put("username", "张三");
  jsonObject.put("age", 24);
  jsonObject.put("sex", "男");
  System.out.println("java--->json \n " + jsonObject.toString());

  //json字符串转xml字符串
  String jsonStr = "{\"username\":\"张三\",\"password\":\"123456\",\"age\":\"24\"}";
  JSONObject jsonObject = JSONObject.fromObject(jsonStr);
  XMLSerializer xmlSerializer = new XMLSerializer();
  xmlSerializer.setRootName("user_info");
  xmlSerializer.setTypeHintsEnabled(false);
  String xml = xmlSerializer.write(jsonObject);
  System.out.println("json--->xml \n" + xml);

  //xml字符串转json字符串
  String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><user_info><password>123456</password><username>张三</username></user_info>";
  XMLSerializer xmlSerializer = new XMLSerializer();
  JSON json = xmlSerializer.read(xml);
  System.out.println("xml--->json \n" + json.toString());

  //javaBean转json字符串
  UserInfo userInfo = new UserInfo();
  userInfo.setUsername("张三");
  userInfo.setPassword("123456");
  JSONObject jsonObject = JSONObject.fromObject(userInfo);
  System.out.println("JavaBean-->json \n" + jsonObject.toString())

  //javaBean转xml字符串
  UserInfo userInfo = new UserInfo();
  userInfo.setUsername("zhangsan");
  userInfo.setPassword("66666");
  JSONObject jsonObject = JSONObject.fromObject(userInfo);
  XMLSerializer xmlSerializer = new XMLSerializer();
  String xml = xmlSerializer.write(jsonObject, "UTF-8");
  System.out.println("javaBean--->xml \n" + xml);
```

### SpringMVC中使用注解@ResponseBody，@RequestBody传递json数据

在SpringMVC中，可以使用@RequestBody和@ResponseBody两个注解，分别完成请求报文到对象和对象到响应报文的转换。

* @ResponseBody
该注解用于将Controller的方法返回的对象，通过适当的HttpMessageConverter转换为指定格式后，写入到Response对象的body数据区。即可以将返回的对象（带有数据的javabean的集合List或Map）转换成JSON。

* @RequestBody
该注解用于读取Request请求的body部分数据，使用系统默认配置的HttpMessageConverter进行解析，然后把相应的数据绑定到要返回的对象上。

* HttpMessageConverter

![](https://pan.layne666.cn/images/2021/12/02/YCFOU1taK5.png)


* jackson包

* ajax使用要注意的

	* JSON.stringify()和$.parseJSON()实现字符串和json对象之间的转换。注意要传过去的data是一个字符串。

	* 要设置contentType: 'application/json',而不是使用默认值: "application/x-www-form-urlencoded".