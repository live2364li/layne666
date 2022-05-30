---
title: Java对象的浅克隆和深克隆
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/Zgnf5gLfaO.png
date: 2019-09-02 16:09:41
updated: 2019-09-02 16:09:41
categories: 
  - Java
tags: 
  - Java
  - 克隆
---

## 引言

在Object基类中，有一个方法叫clone，产生一个前期对象的克隆，克隆对象是原对象的拷贝，由于引用类型的存在，有深克隆和浅克隆之分，若克隆对象中存在引用类型的属性，深克隆会将此属性完全拷贝一份，而浅克隆仅仅是拷贝一份此属性的引用。首先看几个容易犯的小问题

- clone方法是Object类的，并不是Cloneable接口的，Cloneable只是一个标记接口，标记接口是用用户标记实现该接口的类具有某种该接口标记的功能，常见的标记接口有三个：`Serializable`、`Cloneable`、`RandomAccess`，没有实现Cloneable接口，那么调用clone方法就会报出`CloneNotSupportedException`异常。

- Object类中的clone方法是protected修饰的，这就表明我们在子类中不重写此方法，就在子类外无法访问，因为这个protected权限是仅仅能在Object所在的包和子类能访问的，这也验证了子类重写父类方法权限修饰符可以变大但不能变小的说法。

  ```java
  protected native Object clone() throws CloneNotSupportedException
  ```

- 重写clone方法，内部仅仅是调用了父类的clone方法，其实是为了扩大访问权限，当然你可以把`protected`改为`public`，以后再继承就不用重写了。当然只是浅克隆的clone函数，深克隆就需要修改了。

  ```java
  @Override
  protected Object clone() throws CloneNotSupportedException {
      return super.clone();
  }
  ```

- 属性是String的情况，String也是一个类，那String引用类型吗？String的表现有的像基本类型，归根到底就是因为`String不可改变`，克隆之后俩个引用指向同一个String，但当修改其中的一个，改的不是String的值，却是新生成一个字符串，让被修改的引用指向新的字符串。外表看起来就像基本类型一样。

## 浅克隆

浅克隆就是引用类型的属性无法完全复制，类User中包含成绩属性Mark，Mark是由chinese和math等等组成的，浅克隆失败的例子。

```java
class Mark{
    private int chinese;
    private int math;
    public Mark(int chinese, int math) {
        this.chinese = chinese;
        this.math = math;
    }

    public void setChinese(int chinese) {
        this.chinese = chinese;
    }

    public void setMath(int math) {
        this.math = math;
    }

    @Override
    public String toString() {
        return "Mark{" +
                "chinese=" + chinese +
                ", math=" + math +
                '}';
    }
}
public class User implements Cloneable{
    private String name;
    private int age;
    private Mark mark;

    public User(String name, int age,Mark mark) {
        this.name = name;
        this.age = age;
        this.mark = mark;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", mark=" + mark +
                '}';
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    public static void main(String[] args) throws CloneNotSupportedException {
        Mark mark = new Mark(100,99);
        User user = new User("user",22,mark);
        User userClone = (User) user.clone();
        System.out.println("原来的user："+user);
        System.out.println("克隆的user："+userClone);
        //修改引用类型的mark属性
        user.mark.setMath(60);
        System.out.println("修改后原来的user："+user);
        System.out.println("修改后克隆的user："+userClone);
    }
}
```

```java
输出结果为：　　　
    原来的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}
    克隆的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}　　　
    修改后原来的user：User{name='user', age=22, mark=Mark{chinese=100, math=60}}
    修改后克隆的user：User{name='user', age=22, mark=Mark{chinese=100, math=60}}
```

> 很清楚的看到user的mark更改后，被克隆的user也修改了。而要想不被影响，就需要深克隆了。

## 深克隆

### 方式一：clone函数的嵌套调用

既然引用类型无法被完全克隆，那将引用类型也实现Cloneable接口重写clone方法，在User类中的clone方法调用属性的克隆方法，也就是方法的嵌套调用。

```java
class Mark implements Cloneable{
    private int chinese;
    private int math;
    public Mark(int chinese, int math) {
        this.chinese = chinese;
        this.math = math;
    }
    public void setChinese(int chinese) {
        this.chinese = chinese;
    }
    public void setMath(int math) {
        this.math = math;
    }
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
    @Override
    public String toString() {
        return "Mark{" +
                "chinese=" + chinese +
                ", math=" + math +
                '}';
    }
}
public class User implements Cloneable{
    private String name;
    private int age;
    private Mark mark;

    public User(String name, int age,Mark mark) {
        this.name = name;
        this.age = age;
        this.mark = mark;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", mark=" + mark +
                '}';
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        User user = (User) super.clone();
        user.mark = (Mark) this.mark.clone();
        return user;
    }

    public static void main(String[] args) throws CloneNotSupportedException {
        Mark mark = new Mark(100,99);
        User user = new User("user",22,mark);
        User userClone = (User) user.clone();
        System.out.println("原来的user："+user);
        System.out.println("克隆的user："+userClone);
        //修改引用类型的mark属性
        user.mark.setMath(60);
        System.out.println("修改后原来的user："+user);
        System.out.println("修改后克隆的user："+userClone);
    }
}
```

```java
输出结果为：　
    原来的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}
    克隆的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}
    修改后原来的user：User{name='user', age=22, mark=Mark{chinese=100, math=60}}
    修改后克隆的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}
```

### 方式二：序列化

上一种方法已经足够满足我们的需要，但是如果类之间的关系很多，或者是有的属性是数组呢，数组可无法实现Cloneable接口（我们可以在clone方法中手动复制数组），但是每次都得手写clone方法，很麻烦，而序列化方式只需要给每个类都实现一个Serializable接口，也是标记接口，最后同序列化和反序列化操作达到克隆的目的（包括数组的复制）。

```java
import java.io.*;
class Mark implements Serializable {
    private int chinese;
    private int math;
    public Mark(int chinese, int math) {
        this.chinese = chinese;
        this.math = math;
	}
    public void setChinese(int chinese) {
        this.chinese = chinese;
    }
    public void setMath(int math) {
        this.math = math;
    }
    @Override
    public String toString() {
        return "Mark{" +
                "chinese=" + chinese +
                ", math=" + math +
                '}';
    }
}
public class User implements Serializable{
    private String name;
    private int age;
    private Mark mark;

    public User(String name, int age,Mark mark) {
        this.name = name;
        this.age = age;
        this.mark = mark;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", mark=" + mark +
                '}';
    }
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        Mark mark = new Mark(100,99);
        User user = new User("user",22,mark);

        ByteArrayOutputStream bo = new ByteArrayOutputStream();
        ObjectOutputStream oo = new ObjectOutputStream(bo);
        oo.writeObject(user);//序列化
        ByteArrayInputStream bi = new ByteArrayInputStream(bo.toByteArray());
        ObjectInputStream oi = new ObjectInputStream(bi);
        User userClone = (User) oi.readObject();//反序列化

        System.out.println("原来的user："+user);
        System.out.println("克隆的user："+userClone);
        user.mark.setMath(59);
        System.out.println("修改后原来的user："+user);
        System.out.println("修改后克隆的user："+userClone);
    }
}
```

```java
输出结果：　　　　
    原来的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}
    克隆的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}
    修改后原来的user：User{name='user', age=22, mark=Mark{chinese=100, math=60}}
    修改后克隆的user：User{name='user', age=22, mark=Mark{chinese=100, math=99}}
```

参考博文：https://www.cnblogs.com/gollong/p/9668699.html