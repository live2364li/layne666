---
title: Java设计模式之单例模式
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/Tjslzo1Pzz.jpg
date: 2019-09-17 19:17:24
updated: 2019-09-17 19:17:24
categories: 
  - 设计模式
tags: 
  - Java
  - 设计模式
---

## 模式介绍

所谓类的单例设计模式，就是 采取一定的方法保证在整个的软件系统中，对某个类`只能存在一个对象实例`，并且该类`只提供一个取得其对象实例的方法(静态方法)`。

比如 Hibernate 的 SessionFactory，它充当数据存储源的代理，并负责创建`Session`对象。SessionFactory 并不是轻量级的，一般情况下，一个项目通常只需要一个`SessionFactory`就够，这是就会使用到单例模式。

## 八种实现方式

### 饿汉式（静态常量）

1. 构造器私有化 (防止 new )
2. 类的内部创建对象
3. 向外暴露一个静态的公共方法

代码实现如下：

```java
//饿汉式(静态变量)
class Singleton {
    //1. 构造器私有化
    private Singleton() {}
    //2. 本类内部创建对象实例
    private final static Singleton instance = new Singleton();
    //3. 提供一个公有的静态方法，返回实例对象
    public static Singleton getInstance() {
        return instance;
    }
}
```

**优缺点说明：**

1. 优点：这种写法比较简单，就是在类装载的时候就完成实例化。`避免了线程同步问题`。
2. 缺点：在类装载的时候就完成实例化，没有达到`Lazy Loading`的效果。如果从始至终从未使用过这个实例，则会造成内存的浪费。
3. 这种方式基于`classloder 机制`避免了多线程的同步问题，不过，instance 在类装载时就实例化，在单例模式中大多数都是调用 getInstance 方法，但是导致类装载的原因有很多种，因此不能确定有其他的方式（或者其他的静态方）导致类装载，这时候初始化 instance 就没有达到`lazy loading`的效果。

**结论：**这种单例模式可用，可能造成`内存浪费`。

### 饿汉式（静态代码块）

代码实现如下：

```java
//饿汉式(静态变量)
class Singleton {
    //1. 构造器私有化
    private Singleton() {}
    //2. 本类内部创建对象实例
    private static Singleton instance;
    
    //3. 在静态代码块中，创建对象实例 
    static { 
        instance = new Singleton();
    }
    //4. 提供一个公有的静态方法，返回实例对象
    public static Singleton getInstance() {
        return instance;
    }
}
```

**优缺点说明：**

1. 这种方式和上面的方式其实类似，只不过将类实例化的过程放在了``静态代码块``中，也是在类装载的时候，就执行静态代码块中的代码，初始化类的实例。
2. 优缺点和上面是一样的。

**结论：**这种单例模式可用，但是可能造成`内存浪费`。

### 懒汉式(线程不安全)

代码实现如下：

```java
//懒汉式(线程不安全)
class Singleton {
    private Singleton() {}
    private static Singleton instance;
    
    //提供一个静态的公有方法，当使用到该方法时，才去创建 instance
    public static Singleton getInstance() {
        if(instance == null) {
            instance = new Singleton();
        }
       return instance;
    }
}
```

**优缺点说明：**

1. 起到了`Lazy Loading`的效果，但是只能在`单线程`下使用。
2. 如果在多线程下，一个线程进入了 if (singleton == null) 判断语句块，还未来得及往下执行，另一个线程也通过了这个判断语句，这时便会`产生多个实例`。所以在多线程环境下不可使用这种方式。

**结论：**在实际开发中， 不要使用这种方式。

### 懒汉式(线程安全，同步方法)

代码实现如下：

```java
//懒汉式(线程安全，同步方法)
class Singleton {
    private Singleton() {}
    private static Singleton instance;

    //提供一个静态的公有方法，加入同步处理的代码，解决线程安全问题
    public static synchronized Singleton getInstance() {
        if(instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}
```

**优缺点说明：**

1. 解决了`线程安全问题`。
2. 效率太低了，每个线程在想获得类的实例时候，执行 getInstance() 方法都要进行同步。而其实这个方法只执行一次实例化代码就够了，后面的想获得该类实例，直接 return 就行了。 `方法进行同步效率太低`。

**结论：**在实际开发中， 不推荐使用这种方式。

### 懒汉式(线程安全，同步代码块)

代码实现如下：

```java
//懒汉式(线程安全，同步代码块)
class Singleton {
    private Singleton() {}
    private static Singleton instance;

    public static Singleton getInstance() {
        if(instance == null) {
            synchronized (Singleton.class){
                instance = new Singleton();
            }
        }
        return instance;
    }
}
```

**结论：**在实际开发中， 不推荐使用这种方式。

### 懒汉式(双重检查)

代码实现如下：

```java
//懒汉式(双重检查)
class Singleton {
    private Singleton() {}
    private static volatile Singleton instance;

    //提供一个静态的公有方法，加入双重检查代码，解决线程安全问题, 同时解决懒加载问题
    //同时保证了效率
    public static synchronized Singleton getInstance() {
        if(instance == null) {
            synchronized (Singleton.class) {
                if(instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

**优缺点说明：**

1. `Double-Check`概念是多线程开发中常使用到的，如代码中所示，我们进行了两次 if (singleton == null) 检查，这样就可以保证线程安全了。
2. 这样，实例化代码只用执行一次，后面再次访问时，判断 if (singleton == null)，直接 return 实例化对象，也`避免反复进行方法同步`。
3. `线程安全； 延迟加载； 效率较高`。

**结论：**但由于 JVM 底层内部模型的原因，偶尔会出问题，不建议使用。

### 静态内部类

代码实现如下：

```java
// 静态内部类，推荐使用
class Singleton {
    //构造器私有化
    private Singleton() {}
    private static volatile Singleton instance;

    //写一个静态内部类,该类中有一个静态属性 Singleton
    private static class SingletonInstance {
        private static final Singleton INSTANCE = new Singleton();
    }
    //提供一个静态的公有方法，直接返回 SingletonInstance.INSTANCE
    public static synchronized Singleton getInstance() {
        return SingletonInstance.INSTANCE;
    }
}
```

**优缺点说明：**

1. 这种方式采用了`类装载`的机制来保证初始化实例时只有一个线程。
2. 静态内部类方式在 Singleton 类被装载时并不会立即实例化，而是在需要实例化时，调用 getInstance 方法，才会装载 SingletonInstance 类，从而完成 Singleton 的实例化。
3. 类的静态属性只会在第一次加载类的时候初始化，所以在这里，`JVM`帮助我们保证了线程的安全性，在类进行初始化时，别的线程是无法进入的。
4. 优点： 避免了线程不安全，利用 静态内部类特点实现延迟加载，效率高。
   

**结论：**推荐使用。

###  枚举

代码实现如下：

```java
//使用枚举，可以实现单例, 推荐
enum Singleton {
    INSTANCE; //属性
    public void sayOK() {
        System.out.println("OK");
    }
}
```

**优缺点说明：**

1. 这借助 JDK1.5 中添加的枚举来实现单例模式。不仅能`避免多线程同步问题`，而且还能`防止反序列化重新创建新的对象`。
2. 这种方式是 Effective Java  作者 Josh Bloch  提倡的方式。
   

**结论：**推荐使用。

## 总结

1. 单例模式保证了 系统内存中该类只存在一个对象，节省了系统资源，对于一些需要频繁创建销毁的对象，使用单例模式可以提高系统性能。
2. 当想实例化一个单例类的时候，必须要记住使用相应的获取对象的方法，而不是使用 new。
3. 单例模式 使用的场景：需要`频繁的进行创建和销毁的对象`、创建对象时耗时过多或耗费资源过多(即：重量级对象)，但又经常用到的对象、 工具类对象、频繁访问数据库或文件的对象(比如 数据源、session  工厂等)。