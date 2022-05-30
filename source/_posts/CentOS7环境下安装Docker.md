---
title: CentOS7环境下安装Docker
copyright_author_href: https://layne666.cn
cover: https://pan.layne666.cn/images/2021/12/02/1S20LO6vQb.jpg
date: 2019-08-21 00:40:08
updated: 2019-08-21 00:40:08
categories: 
  - CentOS
tags: 
  - CentOS
  - Docker
---

## 先决条件

### 系统要求

在安装Docker Engine - Community之前，需要准备好CentOS 7的维护版本（不支持存档版本）。

该`centos-extras`库必须启用。默认情况下，此存储库已启用，但如果已将其禁用，则需要 [重新启动](https://wiki.centos.org/AdditionalResources/Repositories)。

而`overlay2`建议使用存储驱动程序。

### 卸载旧版本

较旧版本的Docker被称为`docker`或`docker-engine`。如果已安装这些，请卸载它们以及相关的依赖项。

```shell
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

## 安装Docker Engine - Community

根据需要以不同方式安装Docker Engine - Community：

1. 大多数用户 [设置Docker的存储库](https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository)并从中进行安装，以便于安装和升级任务。**这是推荐的方法**。

2. 有些用户 下载RPM软件包并 [手动安装](https://docs.docker.com/install/linux/docker-ce/centos/#install-from-a-package)并完全手动管理升级。这在诸如在没有访问互联网的气隙系统上安装Docker的情况下非常有用。

3. 在测试和开发环境中，一些用户 选择使用自动 [便捷脚本](https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-convenience-script)来安装Docker。

### 使用存储库安装（推荐）

在新主机上首次安装Docker Engine - Community之前，需要设置Docker存储库。之后，就可以从存储库安装和更新Docker。

#### 设置存储库进行安装

1. 安装所需的包。`yum-utils`提供了`yum-config-manager` 效用，并`device-mapper-persistent-data`和`lvm2`由需要 `devicemapper`存储驱动程序。

   ```shell
   $ sudo yum install -y yum-utils \
     device-mapper-persistent-data \
     lvm2
   ```

2. 使用以下命令设置**稳定**存储库。

   ```shell
   $ sudo yum-config-manager \
       --add-repo \
       https://download.docker.com/linux/centos/docker-ce.repo
   ```

#### 安装Docker Engine - Community

1. 安装*最新版本*的Docker Engine - 社区和容器，或者转到下一步安装特定版本：

    ```shell
   $ sudo yum install docker-ce docker-ce-cli containerd.io
   ```

   如果提示接受GPG密钥，请验证指纹是否匹配`060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35`，如果匹配，则接受该指纹 。

2. 要安装特定版本的Docker Engine - Community，请列出repo中的可用版本，然后选择并安装：

   一个。列出并对您的仓库中可用的版本进行排序。此示例按版本号对结果进行排序，从最高到最低，并被截断：

   ```shell
   $ yum list docker-ce --showduplicates | sort -r
   
   docker-ce.x86_64  3:18.09.1-3.el7                     docker-ce-stable
   docker-ce.x86_64  3:18.09.0-3.el7                     docker-ce-stable
   docker-ce.x86_64  18.06.1.ce-3.el7                    docker-ce-stable
   docker-ce.x86_64  18.06.0.ce-3.el7                    docker-ce-stable
   ```

   返回的列表取决于启用的存储库，并且特定于您的CentOS版本（`.el7`在此示例中以后缀表示）。

   通过其完全限定的包名称安装特定版本，包名称（`docker-ce`）加上从第一个冒号（`:`）开始的版本字符串（第2列），直到第一个连字符，用连字符（`-`）分隔。例如，`docker-ce-18.09.1`。

   ```shell
   $ sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
   ```

3. 启动Docker

   ```shell
   $ sudo systemctl start docker
   ```

4. 通过运行`hello-world` 映像验证是否正确安装了Docker Engine - 社区

   ```shell
   $ sudo docker run hello-world
   ```

   此命令下载测试映像并在容器中运行它。当容器运行时，它会打印一条信息性消息并退出。

### 下载包手动安装

如果您无法使用Docker的存储库来安装Docker，则可以下载`.rpm`适用于您的发行版的 文件并手动安装。每次要升级Docker Engine - Community时，都需要下载新文件。

1. 转到 <https://download.docker.com/linux/centos/7/x86_64/stable/Packages/> 并下载`.rpm`要安装的Docker版本的文件。

   > **注意**：要安装**每晚** 或**测试**（预发布）包，`stable`请将上述URL中的单词更改为`nightly`或`test`。

2. 安装Docker Engine - 社区，将下面的路径更改为您下载Docker软件包的路径

   ```shell
   $ sudo yum install /path/to/package.rpm
   ```

3. 启动Docker

   ```shell
   $ sudo systemctl start docker
   ```

4. 通过运行`hello-world` 映像验证是否正确安装了Docker Engine - 社区

   ```shell
   $ sudo docker run hello-world
   ```

   此命令下载测试映像并在容器中运行它。当容器运行时，它会打印一条信息性消息并退出。

### 使用便捷脚本安装

Docker在[get.docker.com](https://get.docker.com/) 和[test.docker.com上](https://test.docker.com/)提供了便捷脚本，用于快速，非交互地将Docker Engine - Community的边缘和测试版本安装到开发环境中。脚本的源代码位于 [`docker-install`存储库中](https://github.com/docker/docker-install)。 **建议不要在生产环境中使用这些脚本**。

此示例使用[get.docker.com](https://get.docker.com/)上的脚本在[Linux](https://get.docker.com/)上安装最新版本的Docker Engine - Community。要安装最新的测试版本，请改用[test.docker.com](https://test.docker.com/)。在下面的每个命令中，用`test`替换每次出现的`get`。

```shell
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh

<output truncated>
```

如果您使用便捷脚本安装了Docker，则应直接使用软件包管理器升级Docker。重新运行便捷脚本没有任何好处，如果它尝试重新添加已添加到主机的存储库，则可能会导致问题。

## 卸载Docker Engine - Community

1. 卸载Docker包：

   ```shell
   $ sudo yum remove docker-ce
   ```

2. 主机上的镜像，容器，数据卷或自定义配置文件不会自动删除。要删除所有镜像，容器和数据卷：

   ```shell
   $ sudo rm -rf /var/lib/docker
   ```
