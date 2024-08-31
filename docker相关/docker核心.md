# docker 核心技术

镜像搜索 docker search [镜像名称]

镜像拉取 docker pull [镜像名称]

镜像删除 docker rmi [镜像名称、id]

镜像重命名 docker tag [原镜像名]:[版本号] [新镜像名]:[版本号]

镜像导出 docker save -o [导出镜像名.tar] [本地镜像名] 

镜像导入 docker load < [镜像压缩文件名] 
        docker load --input [被导入镜像压缩文件] 

镜像详细信息 docker inspect [命令参数] [镜像id]

查看本地镜像历史 docker history [镜像名称]:[镜像版本] / [镜像id]

创建镜像 cat [导入镜像名称] | docker import - [设置镜像名称]


### 创建待启动容器 

```
#作用
   利用镜像创建出一个created 状态的待启动容器
#命令格式
   docker create [options] IMAGE [COMMAND] [arg...]   
#options
   -t, --tty            分配虚拟终端
   -i, --interactive    即使没有连接也要保持STDIN打开
       --name           为容器起名
#command
   command 表示容器启动后在容器中执行的命令
   arg     执行command命令提供的参数
   
 docker create -it --name xxx          
```

### 启动容器
 启动容器有三种方式
 1.启动待启动或已关闭容器
 2.基于镜像创建一个容器并启动
 3.守护进程方式启动
 
```
#作用
 讲一个或多个处于创建，关闭状态的容器启动起来
 
#命令格式
 docker start [容器名称] 或 [容器ID]
#命令参数
  -a,  --attach         将当前shell的stdout、stderr 连接到容器上
  -i, --interactive    将当前shell的STDIN连接到容器上
  
  docker start -a xxx 
```

### 创建新的容器并启动

```
 #作用
   利用镜像创建并启动一个容器
 #命令格式
  docker run [命令参数] [镜像名称] [执行的命令]
 #命令参数
   -t, --tty            分配虚拟终端
   -i, --interactive    即使没有连接也要保持STDIN打开
       --name           为容器起名
   -d, --detach         在后台运行并打印容器id
   --rm                 当容器退出后，自动删除
   
```

### 容器暂停

```
#作用 
 暂停一个或多个处于运行中的容器
 
#命令格式
  docker pause [容器名称] 、[容器id]
  
```

### 容器取消暂停

```
#作用
 取消一个或多个处于暂停状态的容器，恢复运行
 
#命令格式
 docker unpause [容器名称] 、[容器id]
```

### 重启

```
#作用
 重启一个或多个处于运行，暂停，关闭或新建状态的容器
#命令格式
 docker restart [容器名称] 、[容器id]
#命令参数
  -t, --time  int     重启前等待时间,单位s(默认10s)
  
  docker restart -t 20 xxxx  
```

### 关闭

```
#作用
 延迟关闭一个或多个处于暂停，运行状态的容器
 
#命令格式
 docker stop [容器名称] 、[容器id]
```

### 终止

```
#作用
 强制并立即关闭一个或多个处于暂停，运行状态的容器
 
#命令格式
 docker kill  [容器名称] 、[容器id]
```

### 删除


```
#作用 
  删除一个或多个容器
#命令格式
  docker rm [容器名称] 、[容器id]
#强制删除
  docker rm -f [容器名称] 、[容器id]
#批量删除
  docker rm -f $(docker ps -a -q)  
```


### 进入，退出容器
#### 进入
 进入容器有三种方式
 1.创建同时进入容器
 2.手工方式进入
 3.生产方式进入
 
#### 创建并进入
 
```
#命令格式
docker run --name [container_name] -it [docker_name] /bin/bash
```

#### 手动方式进入

```
#命令格式
docker exec -it [容器id] /bin/bash
```

#### 生产方式进入

```
#创建脚本
#!/bin/bash

#定义进入仓库函数
docker_in(){
 NAME_ID=$1
 PID=${docker inspect --format {{.state.pid}} $NAME_ID} 
 nsenter --target $PID --mount --uts --ipc --net --pid
}
docker_in $1
```

### 基于容器创建镜像

**方法一**
```
#命令格式
docker commit -m '改动信息' -a '作者信息' [container_id] [new_image:tag]

#查看
docker images

```


**方法二**

```
#命令格式
docker export [容器id] > 模板文件名.tar

#导入镜像
cat xxx.tar | docker import - xxxxxx
```

** 导入(import)导出(export)与保存(save)加载(load)的区别**
import 可以重新指定镜像的名字 load不可以
export导出的镜像文件小于save保存的镜像
export导出(import)是根据容器拿到的镜像，再导入时会丢失镜像所有的历史

### 查看运行日志


```
#命令格式
docker logs [容器id] 

```

### 查看容器详情


```
#命令格式
docker inspect [容器id]

#查看容器网络信息
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [容器id]
```

### 查看端口

```
#命令格式
docker port [容器id]
#没有反应就是没有和宿主机关联
```

## 数据
容器之间数据共享通过：**数据卷(Data Volumes)**和**数据卷容器**来实现


```
#命令格式
docker run -v
  -v, --volume list    挂载一个数据卷(默认为空)
```
### 数据卷
#### 目录

```
#命令格式
docker run -itd --name [容器名字] -v [宿主机目录]:[容器目录] [镜像名称]

```

#### 文件

```
#命令格式
docker run -itd --name [容器名字] -v [宿主机文件]:[容器文件] [镜像名称]
```

### 数据卷容器
数据卷容器也是一个容器，但是他的目的是专门用来提供其他容器挂载的。使用特定容器维护数据卷。

```
#命令格式 
docker run --volumes-from list   从指定的容器挂载卷，默认为空
```

数据卷容器操作流程：
1.创建数据卷容器
2.其他容器挂载数据卷容器

#### 创建数据卷

```
#命令格式
docker create -v [容器数据卷目录] --name [容器名字] [镜像名字]

#执行示例
docker create -v /data --name v1-test1 xxx
```

#### 创建两个容器，同时挂载数据卷容器

```
#命令格式
docker run --volumes-from [数据卷容器id、name] -tid --name [容器名字] [镜像名称] 

#创建vc-test1 容器
docker run --volumes-from xxxx -tid --name vc-test1 xxx /bin/bash 
```

**数据备份方案：**

- 1.创建一个挂载数据卷容器的容器
- 2.挂载宿主机本地目录作为备份数据卷
- 3.将数据卷容器的内容备份到宿主机本地目录挂载的数据卷中
- 4.完成备份操作后销毁创建的容器


```
#命令格式
docker run --rm --volumes-from [数据卷容器id,name] -v [宿主机目录]:[容器目录] [镜像名称] [备份命令]

```

