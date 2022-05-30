---
title: 如何解决Maven jar包冲突
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/nePOy2MgOM.png
date: 2019-08-20 19:56:58
updated: 2019-08-20 19:56:58
categories: 
  - Maven
tags: 
  - Maven
---

## 依赖传递

假设我们现在有一个多模块项目，依赖关系如图，我们在 st-web 模块中引入st-dal依赖时，st-common-lib 这个依赖也会被我们引入，这个就是`依赖传递`，下表中列出了 scope 在依赖过程中发生的变化，列标题为被依赖的模块的 `scope`

![](https://pan.layne666.cn/images/2021/12/02/Em1AnYF4Ag.png)

|          | **compile** | **test** | **provided** | **runtime** |
| -------- | ----------- | -------- | ------------ | ----------- |
| compile  | compile     | -        | -            | runtime     |
| test     | test        | -        | -            | test        |
| provided | provided    | -        | provided     | provided    |
| runtime  | runtime     | -        | -            | runtime     |

## 依赖仲裁

依赖仲裁就是当项目中引入的jar包，groupId （公司域名倒过来）和artifactId （功能命令）一样，但是 version 不一样，应该选用哪一个 version ？也经常被人叫做`依赖冲突`

### 最短路径原则

假如说我们现在的项目依赖关系如图？那么 maven 会选用 st-common-lib 的那个版本呢？

答案是1.1这个版本，st-web 到 st-common-lib(1.1) 的距离为1，st-web 到 st-common-lib(1.0) 的距离为2，选择距离短的，即`最短路径原则`

![](https://pan.layne666.cn/images/2021/12/02/zI33USAXab.jpg)

如何看依赖的距离关系呢？前文说过，执行如下命令打印出全局的依赖树，层级关系特别清楚

```shell
mvn dependency:tree > show.txt 
```

### 声明优先原则

项目依赖如图，路径一样，会选用 st-common-lib 的哪个版本呢？这就得看你在 pom 文件中先声明是哪个依赖，如果在 pom.xml 中，st-remote-invoker 写在前面，就会用1.0这个版本，如果 st-dal 写在前面，则会用1.1这个版本

![](https://pan.layne666.cn/images/2021/12/02/t06roRUiDJ.jpg)

## 依赖排除

去掉间接引入的jar包

如不想用 `spring boot` 默认提供的 log，想集成第三方的 log 时，或者说上面依赖仲裁的第二个例子中，只想用 st-common-lib 的1.1版本，就可以把1.0版本排除掉

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

参考博文：https://mp.weixin.qq.com/s/jyWr0N6pPvTNkfjTu94VPA