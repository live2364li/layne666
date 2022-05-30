---
title: Lombok常用注解
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/hcMqrxDIYX.jpg
date: 2019-04-04 14:50:20
updated: 2019-04-04 14:50:20
categories: 
  - Java
tags: 
  - Lombok
---

## @NonNull

说到 `NullPointerException`，可能会是所有 `Java` 搬砖工的噩梦吧？
现在有了@NonNull , 让我们不在忧虑。😊

以下是官方文档说明的翻译：

> 你可以在方法或构造函数的参数上使用 @NonNull 让 lombok 为您生成 null-check 语句。

> 如果 lombok 为您生成整个方法或构造函数（例如 @Data），Lombok 总是将字段上通常称为 @NonNull 的各种注释视为生成空值检查的信号。 但是现在，在参数上使用 lombok 自己的 @lombok.NonNull 会使得在您自己的方法或构造函数中只插入 null-check 语句。

> null 检查看起来像if (param == null) throw new NullPointerException("param is marked @NonNull but is null"); 并将此语句插入到方法的最顶层。 对于构造函数，将在任何显式 this() 或 super() 调用之后立即插入非空检查。

代码示例如下：
```java
public NonNullExample(@NonNull Person person) {
    super("Hello");
    this.name = person.getName();
  }
```

编译后如下：
```java
 public NonNullExample(@NonNull Person person) {
    super("Hello");
    if (person == null) {
      throw new NullPointerException("person is marked @NonNull but is null");
    } else {
      this.name = person.getName();
    }
  }
```

## @Cleanup

一说到输入流和输出流，我想大家肯定都会想到关闭流来节约资源，什么，你没想到？😂那现在就记住吧！@Cleanup 能对资源进行自动管理，没有麻烦，安全地调用你的`close()`方法。

以下是官方文档说明的翻译：

> 您可以使用 @Cleanup 以确保在代码执行路径退出当前作用域之前自动清除给定资源。您可以通过使用注释注释任何局部变量声明来执行此操作,@Cleanup InputStream in = new FileInputStream("some/file");
结果，在您 in.close() 调用的范围的末尾调用。保证通过 `try / finally` 构造运行此调用。

> 如果您要清理的对象类型没有 close() 方法，但是有其他一些无参数方法，您可以像这样指定此方法的名称：
@Cleanup("dispose") org.eclipse.swt.widgets.CoolBar bar = new CoolBar(parent, 0);
默认情况下，清除方法被假定为 close()。无法调用带有1个或多个参数的清理方法 @Cleanup。

代码示例如下：
```java
public static void main(String[] args) throws IOException {
    @Cleanup InputStream in = new FileInputStream(args[0]);
    @Cleanup OutputStream out = new FileOutputStream(args[1]);
    byte[] b = new byte[10000];
    while (true) {
      int r = in.read(b);
      if (r == -1) break;
      out.write(b, 0, r);
    }
  }
```
编译后如下：
```java
InputStream in = new FileInputStream(args[0]);
    try {
      OutputStream out = new FileOutputStream(args[1]);
      try {
        byte[] b = new byte[10000];
        while (true) {
          int r = in.read(b);
          if (r == -1) break;
          out.write(b, 0, r);
        }
      } finally {
        if (out != null) {
          out.close();
        }
      }
    } finally {
      if (in != null) {
        in.close();
      }
    }
```

## @Getter and @Setter

一开始我们需要手写 `getter` 和 `setter` 方法，但是用了IDE工具之后，就用快捷键一键生成，虽然不用手动敲了，但是看起来代码比较冗杂，不够清楚。而用 @Getter and @Setter 注解，既不用手动写，又清楚简洁。😉

以下是官方文档说明的翻译：
> 您可以使用 @Getter / @Setter 注释任何字段，让 lombok 自动生成默认的 getter / setter。

> public 除非您明确指定 AccessLevel，否则 生成的 getter / setter 方法将如下所示。
访问级别有：public，protected，default，private。

> 您还可以在类上放置 @Getter / @Setter 注释。在这种情况下，就好像您使用注释注释该类中的所有非静态字段。

> 您始终可以使用特殊 AccessLevel.NONE 访问级别手动禁用任何字段的 getter / setter 生成。这使您可以重写的行为 @Getter，@Setter 或 @Data 对类注解。

代码示例如下：
```java
@Getter @Setter private int age = 10;
@Setter(AccessLevel.PROTECTED) private String name;
```

编译后如下：
```java
public int getAge() {
    return age;
}
public void setAge(int age) {
    this.age = age;
}
protected void setName(String name) {
    this.name = name;
}
```
## @ToString

无需启动调试器即可查看您的字段：只需让 lombok 的 @toString 为您生成一个！

> 可以使用 @ToStringlombok 生成 toString() 方法的实现来注释任何类定义。

> 默认情况下，将打印所有非静态字段。如果要跳过某些字段，可以使用以下方法注释这些字段@ToString.Exclude。

> 通过设置 callSuper 为 true，可以将超类实现 toString 的输出包含到输出中

示例代码如下：
```java
@ToString(exclude = "id", callSuper = true, includeFieldNames = true)
public class LombokDemo {
    private int id;
    private String name;
    private int age;
 
    public static void main(String[] args) {
        //输出LombokDemo(super=LombokDemo@48524010, name=null, age=0)
        System.out.println(new LombokDemo());
    }
}
```

## @EqualsAndHashCode

相等更简单：从对象的字段生成 `hashCode` 和 `equals` 实现

> 任意类的定义都可以添加 @EqualsAndHashCode 注解，让 lombok 帮你生成 equals(Object other) 和 hashCode() 方法的实现。

> 默认情况下会使用非静态和非transient型字段来生成，但是你也通过在字段上添加@EqualsAndHashCode.Include 或者 @EqualsAndHashCode.Exclude 修改你使用的字段（甚至指定各种方法的输出）。

> 你也可以通过在类上使用 @EqualsAndHashCode(onlyExplicitlyIncluded = true)，且在特定字段或特定方法上添加 @EqualsAndHashCode.Include 来指定他们。

## @NoArgsConstructor/@AllArgsConstructor 

注解在类上，生成无参构造器或包含所有参数的构造器。

> @NoArgsConstructor 生成的构造器无参数。

> @AllArgsConstructor 在你的类中生成一个将所有字段作为参数的构造器。标记为 @NonNull 的字段将生成对应的 null 检查。

## @Data

1. 生成无参构造方法；
2. 属性的 set / get 方法；
3. 生成 equals(), hashCode(), toString(), canEqual() 方法。

## @Value

1. 有参构造方法；
2. 只添加 @Value 注解，没有其他限制，那么类属性会被编译成 `final` 的，因此只有 get 方法，而没有 set 方法。

## @Builder

> @Builder 允许您使用以下代码自动生成使您的类可实例化所需的代码：Person.builder().name("Adam Savage").city("San Francisco").job("Mythbusters").job("Unchained Reaction").build();

> @Builder 可以放在类，构造函数或方法上。虽然“在类上”和“在构造函数上”模式是最常见的用例，但 @Builder 最容易用“方法”用例来解释。

示例代码如下：
```java
@ToString
@Builder
public class UserExample {
    private Integer id;
    private String name;
    private String address;
}

UserExample userExample = UserExample.builder().id(1).name("aaa").address("bbb").build();
System.out.println(userExample);
```

**注意事项**：

如果类中用了 @Builder 注解，而属性没有任何注解话，那么在你初始化这个类的时候，如果你的属性赋值了默认值，则在你初始化该类后，属性的默认值则无效即获取会产生空指针异常

因为使用了`建造者模式`，那么一般在类内声明字段的时候给字段默认值的方式就是无效的，需要在建造者上动手脚。方式是： 

1. 自定义静态内部类作为建造者，赋予默认值，再使用 @Builder 注解，这个时候 lombok 会补全已有的建造者类，进而使用默认值 
2. 更新的 lombok 有 @Builder.Default 声明，注解在需要默认值的字段上即可。

参考资料：[如何给Lombok Builder提供默认值](https://www.jikewenku.com/talks/8209.html)

## @SneakyThrows

大胆抛出已检查的异常，以前没有人抛出它们！

> @SneakyThrows 可以用来偷偷抛出已检查的异常而不在方法的 throws 子句中实际声明这一点。当然，应该谨慎使用这种有争议的能力。lombok 生成的代码不会忽略，包装，替换或以其他方式修改抛出的已检查异常; 它只是伪造了编译器。在 JVM（类文件）级别上，无论方法的 throws 子句如何，都可以抛出所有异常（无论是否检查），这就是为什么这样做的原因。

示例代码如下：
```java
@SneakyThrows(UnsupportedEncodingException.class)
public String utf8ToString(byte[] bytes) {
return new String(bytes, "UTF-8");
}

@SneakyThrows
public void run() {
throw new Throwable();
}
```

编译后如下：
```java
public String utf8ToString(byte[] bytes) {
    try {
        return new String(bytes, "UTF-8");
    } catch (UnsupportedEncodingException e) {
        throw Lombok.sneakyThrow(e);
    }
}

public void run() {
    try {
        throw new Throwable();
    } catch (Throwable t) {
        throw Lombok.sneakyThrow(t);
    }
}
```

## @Synchronized

synchronized 做得好：不要暴露你的锁。

> @Synchronized 是 synchronized 方法修饰符的更安全的变体。同样 synchronized，注释只能用于静态和实例方法。它的操作类似于 synchronized 关键字，但它锁定在不同的对象上。关键字锁定this，但注释锁定在名为$lockprivate 的字段上。
如果该字段不存在，则会为您创建该字段。如果注释static方法，则注释将锁定在名为的静态字段上 $LOCK。

> 如果需要，您可以自己创建这些锁。在 $lock 和 $LOCK 领域会当然不会，如果你已经自己原创生成的。您还可以通过将其指定为 @Synchronized 注释的参数来选择锁定另一个字段。在此用法变体中，不会自动创建字段，您必须自己显式创建它们，否则将发出错误。

> 锁定 this 或你自己的类对象可能会产生不幸的副作用，因为不受你控制的其他代码也可以锁定这些对象，这可能会导致竞争条件和其他讨厌的线程相关错误。

示例代码如下：
```java
private final Object readLock = new Object();
  
@Synchronized
public static void hello() {
    System.out.println("world");
}

@Synchronized
public int answerToLife() {
    return 42;
}

@Synchronized("readLock")
public void foo() {
    System.out.println("bar");
}
```

编译后如下：
```java
private static final Object $LOCK = new Object[0];
private final Object $lock = new Object[0];
private final Object readLock = new Object();
  
public static void hello() {
    synchronized($LOCK) {
        System.out.println("world");
    }
}

public int answerToLife() {
    synchronized($lock) {
        return 42;
    }   
}

public void foo() {
    synchronized(readLock) {
        System.out.println("bar");
    }
}
```

## @Log

你把 @Log 的变体贴在类上（适用于你使用的日志系统）， 然后，你有一个静态的 `final log` 字段，初始化为你的类的名称，然后就可以使用它来编写日志语句。

有几种选择：
```java
@CommonsLog 创建 private static final org.apache.commons.logging.Log log = org.apache.commons.logging.LogFactory.getLog(LogExample.class);
@Flogger    创建 private static final com.google.common.flogger.FluentLogger log = com.google.common.flogger.FluentLogger.forEnclosingClass();
@JBossLog   创建 private static final org.jboss.logging.Logger log = org.jboss.logging.Logger.getLogger(LogExample.class);
@Log        创建 private static final java.util.logging.Logger log = java.util.logging.Logger.getLogger(LogExample.class.getName());
@Log4j      创建 private static final org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger(LogExample.class);
@Log4j2     创建 private static final org.apache.logging.log4j.Logger log = org.apache.logging.log4j.LogManager.getLogger(LogExample.class);
@Slf4j      创建 private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(LogExample.class);
@XSlf4j     创建 private static final org.slf4j.ext.XLogger log = org.slf4j.ext.XLoggerFactory.getXLogger(LogExample.class);
```
默认情况下，记录器的主题（或名称）将是使用 @Log 注释注释的类的类名。可以通过指定 topic 参数来自定义。例如：`@XSlf4j(topic="reporting")`。

示例代码如下：
```java
@Log
public class LogExample {
  public static void main(String[] args) {
    log.error("Something's wrong here");
  }
}

@Slf4j
public class LogExampleOther {
  public static void main(String[] args) {
    log.error("Something else is wrong here");
  }
}

@CommonsLog(topic="CounterLog")
public class LogExampleCategory {
  public static void main(String[] args) {
    log.error("Calling the 'CounterLog' with a message");
  }
}
```

编译后如下：
```java
public class LogExample {
  private static final java.util.logging.Logger log = java.util.logging.Logger.getLogger(LogExample.class.getName());
  public static void main(String[] args) {
    log.error("Something's wrong here");
  }
}

public class LogExampleOther {
  private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(LogExampleOther.class);
  public static void main(String[] args) {
    log.error("Something else is wrong here");
  }
}

public class LogExampleCategory {
  private static final org.apache.commons.logging.Log log = org.apache.commons.logging.LogFactory.getLog("CounterLog");
  public static void main(String[] args) {
    log.error("Calling the 'CounterLog' with a message");
  }
}
```