---
title: 动态修改logback的日志级别
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/AII3R4VdV8.png
date: 2020-07-05 22:32:42
updated: 2020-07-05 22:32:42
categories: 
  - Logback
tags: 
  - Java
  - Logback
---

前段时间，威哥曾问我：`线上环境的logback日志级别怎么动态修改？`我：？？？

![](https://pan.layne666.cn/images/2021/12/02/veC0Iu7o4K.jpg)

<img src="https://pan.layne666.cn/images/2021/12/02/alUP7qalbg.gif" alt="" data-action="zoom" style="display: inline-block;"> 没了解过呀，不知道咋弄。利用空闲时间研究了下，于是就有了这篇文章！

## logback.xml自动扫描重新加载配置

logback.xml 中的 configuration 标签有 `<configuration scan="true" scanPeriod="60 seconds"> `这样一段配置，其中的`scan`如果设置为 true 的话，项目在启动后就会默认每一分钟自动扫描配置文件，如果有改变则重新加载，而我们还可以设置自动扫描的时间间隔属性`scanPeriod`，可以设置成30秒或者几分钟。

以前在实际的问题排查过程中，可能都是先修改一下 logback.xml 中的`root`标签中的`level`属性，然后替换线上环境服务器项目中 classes 路径下的 logback.xml 文件，然后再重启项目，这样项目就可以重新加载 logback.xml 配置文件。现在只要在 logback.xml 中添加一个属性，以后可以直接在服务器上修改 logback.xml 中`root`的`level`属性或者直接替换整个 logback.xml 文件，然后等一会，项目的日志输出级别就会改变了，不需要再重启项目。

### 源码解析

configuration 标签对应的处理类是`ConfigurationAction`，具体代码如下：

![](https://pan.layne666.cn/images/2021/12/02/uovX87QYJl.png)

![](https://pan.layne666.cn/images/2021/12/02/wokv6oD79o.png)

在`ReconfigureOnChangeTask`的`run`方法里，找到监听的文件，然后判断文件有没有，有的话再判断有没有改，这个改是通过最后修改时间判断的。

![](https://pan.layne666.cn/images/2021/12/02/5cy07xZPEC.png)

![](https://pan.layne666.cn/images/2021/12/02/fNPW2jzID7.png)

如果修改了的话，则进行重新加载 logback 的配置文件。

* 说明：
  * 如果项目是`war`包的形式部署的话，可以在`work`里改；如果项目是`jar`包的形式部署的话，jar 包运行过程中，是不允许直接改 jar 包的配置文件。
  * 要是用这种方式，可以加一个`logger`标签，对包/类单独设置日志输出级别，不要修改全局的日志输出级别

  ```xml
  <logger name="com.thunisoft.xhry.controller" level="debug" additivity="false">
  	<appender-ref ref="FILE" />
  </logger>
  ``` 

## 通过接口动态修改项目的日志级别

也可以写个接口专门去修改项目的日志输出级别。

实现流程如下：

![](https://pan.layne666.cn/images/2021/12/02/8AuThDjkT8.png)

具体代码如下：

```java
/**
 * 修改项目日志输出级别
 *
 * @param rootLevel 全局日志级别
 * @param singleLevel 某个类日志级别
 * @param singlePath 需要单独设置日志输出级别的包/类的全限定名（例:com.thunisoft.xhry.controller）
 * @return
 */
@GetMapping("/changeLevel")
public String changeLevel(String rootLevel, String singleLevel, String singlePath) {
    LoggerContext loggerContext = (LoggerContext) LoggerFactory.getILoggerFactory();
    log.warn("set log rootLevel:{},singleLevel:{},singlePath:{}", rootLevel, singleLevel,
             singlePath);
    if (!StringUtils.isEmpty(rootLevel)) {
        // 设置全局日志级别
        ch.qos.logback.classic.Logger logger = loggerContext.getLogger("root");
        logger.setLevel(Level.toLevel(rootLevel));
    }
    if (!StringUtils.isEmpty(singleLevel)) {
        // 设置某个类日志级别-可以实现定向日志级别调整
        ch.qos.logback.classic.Logger vLogger = loggerContext.getLogger(singlePath);
        if (vLogger != null) {
            vLogger.setLevel(Level.toLevel(singleLevel));
        }
    }
    return "success";
}
```

* 说明：
  * 如果使用接口调用后，配置自动扫描刷新就失效了。

## 通过Actuator动态修改项目的日志级别

在 SpringBoot 应用中，要实现监控的功能，只需要依赖组件`spring-boot-starter-actuator`。它提供了很多监控和管理你的 spring boot 应用的`HTTP`或者`JMX`端点，并且你可以有选择地开启和关闭部分功能。当你的 spring boot 应用中引入依赖之后，将自动拥有审计、健康检查、Metrics监控功能。

默认`A6`项目生成的时候，已经对`Actuator`的所有`ednpoints`放开了，包含 loggers（显示和修改配置的 loggers ）。

![](https://pan.layne666.cn/images/2021/12/02/BoIDItJZVE.png)

这时候，我们启动完项目之后，访问`http://ip:port/context-path/actuator/loggers`就可以看到当前项目所有包/类的日志输出级别了。

![](https://pan.layne666.cn/images/2021/12/02/uIucUP4JIu.png)

如果我们想要查看单个`logger`的日志配置信息，可以访问如下格式的地址：

```java
http://ip:port/context-path/actuator/loggers/{name}
```

![](https://pan.layne666.cn/images/2021/12/02/fUb0ty5b8h.png)

loggers endpoint 同时提供了在应用运行时改变日志级别的能力，比如你想要改变包/类的 logger 等级为 debug，可以发送一个`POST`请求，如下所示：

![](https://pan.layne666.cn/images/2021/12/02/7xJNjZZJMX.png)

再次访问后，发现返回，配置的日志级别为`debug`，生效级别也为`debug`，说明修改成功了！

![](https://pan.layne666.cn/images/2021/12/02/KSXRDgCH7c.png)

### 源码解析

org.springframework.boot.actuate.logging.LoggersEndpoint 类提供两个`readOperation`和一个`writeOperation`，分别用来读取和更改 logger 的 level。比如更改 logger 的 level 时，源码如下：

![](https://pan.layne666.cn/images/2021/12/02/jVnRHwFA35.png)

最终还是调用 org.springframework.boot.logging.logback.LogbackLoggingSystem 的`setLogLevel`方法，其实和第二种实现效果一样！

![](https://pan.layne666.cn/images/2021/12/02/TzBnXBhmdF.png)

## 总结

虽然三种方式经过自己测试都是可以实现这个动态修改日志级别的需求，但第一种方式相比与后两种而言，更吃资源一些，而且需要`重复加载`配置文件，`性能`差一些。至于第二种和第三种，都是通过直接修改内存中的`logger`的日志级别，能直接`生效`，更为好一些。