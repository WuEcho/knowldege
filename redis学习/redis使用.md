# redis使用

## 1.redis概述和安装
### 1.1 安装redis

1.下载redis

```
https://download.redis.io/releases/
```

2.将 redis 安装包拷贝到 /opt/ 目录

3.解压
    
```
tar -zvxf redis-6.2.1.tar.gz
```
4.安装gcc

```
yum install gcc
```
5.进入目录

```
cd redis-6.2.1
```
6.编译

```
make
```
7.执行 make install 进行安装


目录介绍
 
 - redis-benchmark：性能测试工具，可以在自己本子允许，看看自己本子性能如何
 - redis-check-aof：修复有问题的AOF文件，rdb和aof后面讲
 - redis-check-dump：修复有问题的dump.rdb文件
 - redis-sentinel：redis集群使用
 - redis-server：redis服务器启动命令
 - redis-clit：客户端，操作入口

### 1.2 启动redis
方式1：前台启动（不推荐）
    执行 redis-server 命令，这种如果关闭启动窗口，则redis会停止。

方式2：后端启动（推荐）
    后台方式启动后，关闭窗口后，redis不会被停止.
步骤如下
1.复制redis.conf文件到/etc目录
2.使用vi命令修改/etc/redis.config中的配置，将后台启动设置daemonize改为yes，如下
3.启动redis 

```
redis-server /etc/redis.conf
```

4.查看redis进程

```
Echo@EchodeMacBook-Pro ~ % ps -ef | grep redis
  501  1861     1   0 11:45上午 ??         0:08.04 /usr/local/opt/redis/bin/redis-server 127.0.0.1:6379 
  501 10686     1   0  2:03下午 ??         0:00.05 redis-server *:6379 
```
### 1.3、关闭redis

方式1：kill -9 pid

方式2：redis-cli shutdown

### 1.4、进入redis命令窗口
执行 redis-cli 即可进入redis命令窗口，然后就可以执行redis命令了。

### 1.5 redis命令大全

```
http://doc.redisfans.com/
```

## 2.常用命令
**set：添加键值对**

```
127.0.0.1:6379> set key value [EX seconds|PX milliseconds|EXAT timestamp|
PXAT milliseconds-timestamp|KEEPTTL] [NX|XX] [GET]
```

 - NX：当数据库中key不存在时，可以将key-value添加到数据库
 - XX：当数据库中key存在时，可以将key-value添加数据库，与NX参数互斥
 - EX：key的超时秒数
 - PX：key的超时毫秒数，与EX互斥
 - value中若包含空格、特殊字符，需用双引号包裹
 
**get：获取值**

```
get <key>
```
示例

```
> set name ready 
OK
> get name "ready"
```

**apend：追价值**

```
append <key> <value>
将给定的value追加到原值的末尾。
```

示例

```
> set k1 hello 
OK
> append k1 " world" 
(integer) 11 
> get k1 
"hello world"
```
**strlen：获取值的长度**

```
strlen <key>
```
示例

```
> set name ready 
> OK
> strlen name 
> (integer) 5
```

**setnx：key不存在时，设置key的值**

```
setnx <key> <value>
```

示例

```
> flushdb #清空db，方便测试 
> OK
> setnx site "itsoku.com" #site不存在，返回1，表示设置成功 
> (integer) 1 
> setnx site "itsoku.com" #再次通过setnx设置site，由于已经存在了，所以设 置失败，返回0 
> (integer) 0
```

**incr：原子递增1**

```
incr <key>
将key中存储的值增1，只能对数字值操作，如果key不存在，则会新建一个，值为1
```

示例

```
> flushdb #清空db，方便测试 
OK
> set age 30 #age值为30 
OK
> incr age #age增加1，返回31
(integer) 31 
> get age #获取age的值 
"31" 
> incr salary #salary不存在，自动创建一个，值为1 
(integer) 1 
> get salary #获取salary的值
"1"
```

**decr：原子递减1**

```
decr <key>
将key中存储的值减1，只能对数字值操作，如果为空，新增值为-1
```
示例

```
> flushdb #清空db，方便测试 
OK
> set age 30 #age值为30 
OK
> decr age #age递减1，返回29
(integer) 29 
> get age #获取age的值
"29" 
> decr salary #salary不存在，自动创建一个，值为-1 
(integer) -1 
> get salary #获取salary
"-1"
```

**incrby/decrby：递增或者递减指定的数字**

```
incrby/decrby <key> <步长>
将key中存储的数字值递增指定的步长，若key不存在，则相当于在原值为0的值上递增指定的步
长。
```
示例

```
> set salary 10000 #设置salary为10000 
OK
> incrby salary 5000 #salary添加5000，返回15000 
(integer) 15000 
> get salary #获取salary 
"15000" 
> decrby salary 800 #salary减去800，返回14200 
(integer) 14200 
> get salary #获取salary 
"14200"
```

**mset：同时设置多个key-value**

```
mset <key1> <value1> <key2> <value2> ...
```
示例

```
> mset name ready age 30 
OK
> get name 
"ready" 
> get age 
"30
```

**mget：获取多个key对应的值**

```
mget <key1> <key2> ...
```
示例

```
> mset name ready age 30 #同时设置name和age 
OK
> mget name age #同时读取name和age的值 
1) "ready"
2) "30"
```

**msetnx：当多个key都不存在时，则设置成功**

```
msetnx <key1> <value1> <key2> <value2> ...
原子性的，要么都成功，或者都失败。
```
示例

```
> flushdb #清空db，方便测试 
OK
> set k1 v1 #设置k1 
OK
> msetnx k1 v1 k2 v2 #当k1和k2都不存在的时候，同时设置k1和k2，由于k1已存 在，所以这个操作失败 (integer) 
0 
> mget k1 k2 #获取k1、k2，k2不存在
1) "v1" 
2) (nil) 
> msetnx k2 v2 k3 v3 #当k2、h3都不存在的时候，同时设置k2和k3，设置成功
(integer) 1 
> mget k1 k2 k3 #后去k1、k2、k3的值 
1) "v1"
2) "v2" 
3) "v3
```

**getrange：获取值的范围，类似java中的substring**

```
getrange key start end
获取[start,end]返回为的字符串
```
示例

```
> set k1 helloworld 
OK
> getrange k1 0 4 
"hello"
> getrange k1 0 5
"hellow"
```

**setrange：覆盖指定位置的值**

```
setrange <key> <起始位置> <value>
```
示例

```
> set k1 helloworld 
OK
> get k1 
"helloworld" 
> setrange k1 1 java 
(integer) 10 
> get k1 
"hjavaworld"
```

**setex：设置键值&过期时间（秒）**

```
setex <key> <过期时间(秒)> <value>
```
示例

```
> setex k1 30 v1 #设置k1的值为v1，有效期100秒
OK
> get k1 #获取k1的值 
"v1" 
> ttl k1 #获取k1还有多少秒失效 
(integer) 20
> ttl k1 #获取k1还有多少秒失效 
(integer) 10
> ttl k3
(integer) -2
> get k3
(nil)
```

**getset：以新换旧，设置新值同时返回旧值**

```
getset <key> <value>
```

示例

```
> set name ready #设置name为ready 
OK
> getset name tom #设置name为tom，返回name的旧值 
"ready" 
> getset age 30 #设置age为30，age未设置过，返回age的旧值为null 
(nil)
```

