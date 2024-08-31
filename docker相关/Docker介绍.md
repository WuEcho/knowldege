# Docker介绍


## 1.概念
　　Docker是一个开源的应用容器引擎，基于Go语言并遵从Apache2.0协议开源。Docker可以让开发者打包他们的应用以及依赖包到一个轻量级，可移植的容器中，然后发布到任何流行的Linux机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口，可重要的是容器性能开销极低。

### 1.1 应用场景

- web应用的自动化打包和发布
- 自动化测试和持续集成，发布
- 在服务型环境中部署和调整数据库或其他的后台应用
- 从头编译或者扩展现有的OpenShift或Cloud Foundry 平台来搭建自己的PaaS环境

## 2.架构

Docker包含三个基本概念：

- **镜像(Image):** Docker镜像（Image），就相当于是一个root文件系统。
- **容器(Container):** 镜像(Image)和容器(Container)的关系，就像是面向对象程序设计中的类和实例一样，镜像是静态的定义，容器是镜像运行时的实体，容器可以被创建，启动，停止，删除，暂停等。
- **仓库(Reposition):** 仓库可以看成一个代码控制中心，用来保存镜像。

Docker使用客户端-服务器(C/S)架构模式，使用远程API来管理和创建Docker容器。Docker容器通过Docker镜像来创建。
![576507-docke](media/15758694694997/576507-docker1.png)

| 概念 | 说明 |
| --- | :-: |
| Docker镜像(Images) | Docker镜像是用于创建Docker容器的模板 |
| Docker容器(Container) | 容器是独立运行的一个或一组应用，是镜像运行时的实体 |
| Docker客户端(Client) | Docker客户端通过命令行或者其他工具使用Docker SDK与Docker的守护进程通信 |
| Docker主机(Host) | 一个物理或者虚拟的机器用于执行Docker守护进程和容器 |
| Docker仓库(Registry) | Docker仓库用于保存镜像，可以理解为代码控制中的代码仓库。一个Docker Registry中可以包含多个仓库(Repository)；每个仓库可以包含多个标签(Tag)；每个标签对应一个镜像通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应软件的各个版本。我们可以通过 <仓库名>，<标签>的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以latest作为默认标签。 |
| Docker Machine | Docker Machine是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker |


## 3.安装

### 3.1 MacOS Docker安装
**使用HomeBrew安装**

```
 $ brew cask install docker
 ==> Creating Caskroom at /usr/local/Caskroom
 ==> We'll set permissions properly so we won't need sudo in the future
 Password:          # 输入 macOS 密码
 ==> Satisfying dependencies
 ==> Downloading https://download.docker.com/mac/stable/21090/Docker.dmg
 ######################################################################## 100.0%
 ==> Verifying checksum for Cask docker
 ==> Installing Cask docker
 ==> Moving App 'Docker.app' to '/Applications/Docker.app'.
 &#x1f37a;  docker was successfully installed!
```
在载入 Docker app 后，点击 Next，可能会询问你的 macOS 登陆密码，你输入即可。之后会弹出一个 Docker 运行的提示窗口，状态栏上也有有个小鲸鱼的图标。

**手动下载安装**
如果需要手动下载，请点击以下链接下载[Stable](https://download.docker.com/mac/stable/Docker.dmg)或[Edge](https://download.docker.com/mac/edge/Docker.dmg)版本的Docker for Mac。如同macOS其他软件一样，安装也非常简单，双击下载的.dmg文件，然后将鲸鱼图标拖拽到Applocation文件夹即可。
![1515480386-7270-1293367-9516b2edf79deee7](media/15758694694997/1515480386-7270-1293367-9516b2edf79deee7.png)从应用中找到 Docker 图标并点击运行。可能会询问 macOS 的登陆密码，输入即可。
![1515480613-7638-docker-app-in-apps](media/15758694694997/1515480613-7638-docker-app-in-apps.png)
点击顶部状态栏中的鲸鱼图标会弹出操作菜单。
![1515480612-6026-whale-in-menu-ba](media/15758694694997/1515480612-6026-whale-in-menu-bar.png)

![1515480613-8590-menu](media/15758694694997/1515480613-8590-menu.png)
启动终端后，通过命令可以检查安装后的 Docker 版本。

```
$ docker --version
Docker version 17.09.1-ce, build 19e2cf6
```
**镜像加速**
在任务栏点击 Docker for mac 应用图标 -> Perferences... -> Daemon -> Registry mirrors。在列表中填写加速器地址`http://hub-mirror.c.163.com`即可。修改完成之后，点击 Apply & Restart 按钮，Docker 就会重启并应用配置的镜像地址了。
![6B76CF7C-DC88-4DB4-8305-31EEF4323372](media/15758694694997/6B76CF7C-DC88-4DB4-8305-31EEF4323372.png)

之后可以通过docker info来查看是否配置成功

```
$ docker info
...
Registry Mirrors:
 http://hub-mirror.c.163.com
Live Restore Enabled: false
```

## 4.Docke镜像加速

国内从 DockerHub 拉取镜像有时会遇到困难，此时可以配置镜像加速器。Docker 官方和国内很多云服务商都提供了国内加速器服务，例如：

- Docker官方提供的中国镜像库：**https://registry.docker-cn.com**
- 七牛云加速器：**https://reg-mirror.qiniu.com**
以Docker官方加速器`https://registry.docker-cn.com`为例进行介绍
**Ubuntu14.04、Debian7Wheezy**
对于使用 upstart 的系统而言，编辑 /etc/default/docker 文件，在其中的 DOCKER_OPTS 中配置加速器地址：
```
DOCKER_OPTS="--registry-mirror=https://registry.docker-cn.com"
```
重新启动服务:

```
$ sudo service docker restart
```

**Ubuntu16.04+、Debian8+、CentOS7**
对于使用 systemd 的系统，请在 /etc/docker/daemon.json 中写入如下内容（如果文件不存在请新建该文件）:
```
{"registry-mirrors":["https://registry.docker-cn.com"]}
```
之后重启服务：
```
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```
**Windows 10**

对于使用 Windows 10 的系统，在系统右下角托盘 Docker 图标内右键菜单选择 Settings，打开配置窗口后左侧导航菜单选择 Daemon。在 Registrymirrors 一栏中填写加速器地址 https://registry.docker-cn.com ，之后点击 Apply 保存后 Docker 就会重启并应用配置的镜像地址了。
![20190610104724909](media/15758694694997/20190610104724909.png)

**Mac OSX**

对于使用 Mac OS X 的用户，在任务栏点击 Docker for mac 应用图标-> Perferences...-> Daemon-> Registrymirrors。在列表中填写加速器地址 https://registry.docker-cn.com 。修改完成之后，点击 Apply&Restart 按钮，Docker 就会重启并应用配置的镜像地址了。
![20190516175257734](media/15758694694997/20190516175257734.png)

**检查加速器是否生效**

检查加速器是否生效配置加速器之后，如果拉取镜像仍然十分缓慢，请手动检查加速器配置是否生效，在命令行执行 docker info，如果从结果中看到了如下内容，说明配置成功。
```
$ docker info
Registry Mirrors:
    https://registry.docker-cn.com/
```


## 5.使用
Docker允许在容器内运行应用程序，使用docker run命令在容器内运行一个应用程序。
输出Hello world
```
Echo@EchodeMacBook-Pro ~ % docker run ubuntu:15.10 /bin/echo "Hello world"
Hello world
```
各个参数解析：

- **docker**: Docker的二进制执行文件
- **run**: 与前面的docker组合来进行一个容器
- **ubuntu:15.10** 指定要运行的镜像，Docker首先从本地主机上查找镜像是否存在，如果不存在，Docker就会从镜像仓库Docker Hub下载公共镜像.
- **/bin/echo "Hello world"** : 在启动的容器里面执行的命令

### 5.1 运行交互式的容器

通过docker的两个参数-i,-t，让docker运行的容器实现"对话"的能力:
```
Echo@EchodeMacBook-Pro ~ % docker run -i -t ubuntu:15.10 /bin/bash
root@da91adefed1a:/# 
```
各个参数解析：

- **-t**: 在新容器内指定一个伪终端或终端
- **-i**: 允许对容器内的标准输入(STDIN)进行交互

其中第二行`root@da91adefed1a:/# `，此时我们已进入一个ubuntu15.10系统的容器
尝试在容器中运行命令**cat/proc/version**和**ls**分别查看当前系统的版本信息和当前目录下的文件列表
```
root@da91adefed1a:/# cat /proc/version
Linux version 4.9.184-linuxkit (root@a8c33e955a82) (gcc version 8.3.0 (Alpine 8.3.0) ) #1 SMP Tue Jul 2 22:58:16 UTC 2019
root@da91adefed1a:/# ls
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
root@da91adefed1a:/# 
```
可以通过运行`exit`命令或者使用`CTRL+D`来退出容器.
```
root@da91adefed1a:/# exit
exit
Echo@EchodeMacBook-Pro ~ % 
```

### 5.2 启动容器

使用以下命令创建一个以进程方式运行的容器
```
Echo@EchodeMacBook-Pro ~ % docker run -d ubuntu:15.10 /bin/sh -c "while true; do echo hello world; sleep 1; done"
1816a0151363d9d719a2e44990332b033ad8a5acfa96c148f01368f42e8fd134
Echo@EchodeMacBook-Pro ~ % 
```
在输出中，没有期望的“hello world”，而是一串长字符串
**1816a0151363d9d719a2e44990332b033ad8a5acfa96c148f01368f42e8fd134**
这个长字符串叫做容器ID，对每个容器来说都是唯一的，可以通过容器ID来查看对应的容器发生了什么。
可以通过**docker ps**来确认容器有在运行：

```
Echo@EchodeMacBook-Pro ~ % docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
a7a8dbba0d05        ubuntu:15.10        "/bin/sh -c 'while t…"   5 hours ago         Up 5 hours                              trusting_hopper
```

输出详情介绍：
**CONTAINER ID**: 容器ID
**IMAGE**: 使用的镜像
**COMMAND** : 启动容器是运行的命令
**CREATED** : 容器的创建时间
**STATUS** : 容器状态
 状态有7种:
  
 - created (已创建) 
 - restarting (重启中)
 - running (运行中)
 - removing (迁移中)
 - paused (暂停)
 - exited (停止)
 - dead (死亡)

 **PORTS** : 容器的端口信息和使用的连接类型(tcp/udp) 
 **NAMES** : 自动分配的容器名称
 在容器内使用**docker logs**命令，查看容器内的标准输出：
 
```
Echo@EchodeMacBook-Pro ~ % docker logs a7a8dbba0d05
hello world
hello world
hello world
hello world
hello world
...
```
 
### 5.3 停止容器
 
我们使用`docker stop`命令来停止容器：
```
Echo@EchodeMacBook-Pro ~ % docker stop a7a8dbba0d05
a7a8dbba0d05
```
通过`docker ps`查看，容器已经停止工作；

```
Echo@EchodeMacBook-Pro ~ % docker ps
``` 
可以看到容器已经不在了。
 
## 6.Docker容器使用
 
docker客户端很简单，可以直接输入docker命令来查看到Docker客户端的所有命令选项

```
Echo@EchodeMacBook-Pro ~ % docker

Usage:	docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/Users/wuxinyang/.docker")
  -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker
                           context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/Users/wuxinyang/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/Users/wuxinyang/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/Users/wuxinyang/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  builder     Manage builds
  config      Manage Docker configs
  container   Manage containers
  context     Manage contexts
``` 
 可以通过命令`docker command --help`更深入的了解指定的Docker命令使用方法。
 比如要查看`docker stats`指令的具体使用方法：
 
```
Echo@EchodeMacBook-Pro ~ % docker stats --help

Usage:	docker stats [OPTIONS] [CONTAINER...]

Display a live stream of container(s) resource usage statistics

Options:
  -a, --all             Show all containers (default shows just running)
      --format string   Pretty-print images using a Go template
      --no-stream       Disable streaming stats and only pull the first result
      --no-trunc        Do not truncate output
```
 
### 6.1 容器使用
**启动容器**
 以下命令使用ubuntu镜像启动一个容器，参数为以命令行模式进入该容器：
 
```
Echo@EchodeMacBook-Pro ~ % docker run -it ubuntu /bin/bash
root@f4b7ce9873c1:/# 
```
 参数说明:

 - **-i**: 交互式操作
 - **-t**: 终端
 - **ubuntu**: ubuntu镜像
 - **/bin/bash**: 放在镜像名后的是命令，这里希望有个交互式Shell,因此用的是/bin/bash
 
 要退出终端，直接输入**exit**
 
```
root@f4b7ce9873c1:/# exit
exit
```
**启动已停止运行的容器** 
 查看所有的容器命令如下：
 
```
Echo@EchodeMacBook-Pro ~ % docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS               NAMES
f4b7ce9873c1        ubuntu              "/bin/bash"              10 minutes ago      Exited (0) 3 minutes ago                          practical_buck
```
 
使用docker start 启动一个停止的容器：

```
Echo@EchodeMacBook-Pro ~ % docker start f4b7ce9873c1
f4b7ce9873c1
``` 
**后台运行**
在大部分的场景下，希望docker的服务是在后台运行的，我们可以用**-d**指定容器的运行模式

```
Echo@EchodeMacBook-Pro ~ % docker run -itd --name ubuntu-test ubuntu /bin/bash
b06abc9345a3d56f2e2285acf0fb5e5372fd8fd943975ea277d14bd79c713fbf

Echo@EchodeMacBook-Pro ~ % docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
b06abc9345a3        ubuntu              "/bin/bash"              2 minutes ago       Up 2 minutes                            ubuntu-test
f4b7ce9873c1        ubuntu              "/bin/bash"              27 minutes ago      Up 13 minutes      
``` 
ps:加入**-d**参数默认不会进入容器，想要进入容器需要使用指令**docker exec** 
 
**停止一个容器** 
停止容器的命令如下：

```
Echo@EchodeMacBook-Pro ~ % docker stop b06abc9345a3
b06abc9345a3
``` 
停止的容器可以通过docker restart重启:

```
Echo@EchodeMacBook-Pro ~ % docker restart b06abc9345a3
b06abc9345a3
```

**进入容器** 
在使用**-d**参数时，容器启动后进入后台。此时想要进入容器，可以通过以下指令进入：

 - docker attach
 - docker exec : 推荐使用docker exec命令，因此为退出容器终端，不会导致容器的停止

**attach命令**  
下面演示使用docker attach命令

```
Echo@EchodeMacBook-Pro ~ % docker attach f4b7ce9873c1
root@f4b7ce9873c1:/# exit
exit
Echo@EchodeMacBook-Pro ~ % docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
Echo@EchodeMacBook-Pro ~ % 
``` 
ps:如果从这个容器退出，会导致容器的停止

**exec命令** 
下面演示使用docker exec命令 
 
```
Echo@EchodeMacBook-Pro ~ % docker exec -it 1816a0151363 /bin/bash
root@1816a0151363:/# exit
exit
Echo@EchodeMacBook-Pro ~ % docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
1816a0151363        ubuntu:15.10        "/bin/sh -c 'while t…"   3 hours ago         Up 3 hours                              distracted_lichterman
```
ps:如果从这个容器退出，不会导致容器的停止，这就是为什么推荐使用docker exec的原因

**导出和导入容器**
 
**导出容器**
如果要导出本地某个容器，可以使用`docker export`命令。 

```
docker export f4b7ce9873c1 > ubuntu.tar
``` 
导出容器f4b7ce9873c1快照到本地文件ubuntu.tar


 






