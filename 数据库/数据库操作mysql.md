# 数据库操作mysql

## 1.1 什么是SQL
SQL是结构化查询语言（Structured Query Language）


### 1.2 SQL标准

由国际标准组织(ISO)制定的，对DBMS的统一操作方式(例如相同的语句可以操作：mysql，oracle等)。

例如SQL99，即1999年制定的标准

> SQL99
>
> （1）是操作所有关系型数据库的规则 
> （2）是第四代语言 
> （3）是一种结构化查询语言 
> （4）只需发出合法合理的命令，就有对应的结果显示

注意，某种DBMS不只会支持SQL标准，而且还会有一些自己独有的语法，比如limit语句只在MySQL中可以使用

### 1.3 SQL的语法

1. SQL语句可以在单行或多行书写，以分号结尾
   ​	有些时候可以不以分号结尾，比如代码中

2. 可以使用空格和缩进来增强语句的可读性

3. MySQL不区分大小写，建议使用大写

### 1.4 SQL99标准的四大分类 ： 

1. DDL数据定义语言（data definition language）

   ​	create table,alter table，drop table，truncate table 。。

2. DML数据操作语言（Data Manipulation Language）

   ​	insert,update,delete 

3. DQL数据查询语言（data query language）

   select

   其实DQL也从DML中分离出来的。

4. DCL数据控制语言（Data Control Language）

   ​	grant 权限 to scott，revoke 权限 from scott 。。。 

5. DCL（事务控制语言）：commit，rollback，rollback to savepoint 。。。

## 二、 数据库的基本操作
### 2.1 在终端连接`mysql`数据库

在终端输入如下命令:
```sql
mysql -u root -p
```
回车后输入密码.
### 2.2 查看数据库版本

```sql
select version();
```
注意:输入命令的时候不要忘记后面的分号

### 2.3 查看当前时间

```sql
select now();
```

### 2.4 退出`mysql`数据库的连接

`exit`或`quit`

### 2.5 显示所有的数据库

```sql
show databases;
```
### 2.6 创建数据库

```sql
create database [if not exists]数据库名 [default charset utf8 collate utf8_general_ci];
```

说明: 
1. 数据库名不要使用中文
2. 由于数据库中将来会存储一些`非ascii`字符, 所以务必指定字符编码, 一般都是指定`utf-8`编码
3. CHARSET 选择 utf8 
   COLLATION 选择 utf8_general_ci 
4. mysql中字符集是utf8，不是utf-8。
5. []里面代码是非必须代码

### 2.7 切换到要操作的数据库

若要操作数据库中的内容, 需要先切换到要操作的数据库

```sql
use 数据库名;
```
### 2.8 查看当前选择的数据库

```sql
select database();
```

### 2.9 删除数据库

```sql
drop database [if exists]数据库名;
```

### 2.10 [扩展]MySQL添加用户、删除用户与授权

DCL数据控制语言（Data Control Language）

通常一个项目创建一个用户。一个项目对应的数据库只有一个，这个用户只能对这个数据库有权限，无法对其他数据库进行操作。

MySql中添加用户,新建数据库,用户授权,删除用户,修改密码(注意每行后边都跟个;表示一个命令语句结束):

#### 1.创建用户

#####1.1 先使用root账户进行登录

登录MYSQL：

@>mysql -u root -p

@>密码:******

#####1.2 创建用户：

```sql
CREATE USER 'username'@'IP地址' [IDENTIFIED BY 'PASSWORD'] 其中密码是可选项；
	用户只能在指定的IP地址上登录
CREATE USER 'username'@'%' [IDENTIFIED BY 'PASSWORD'] 其中密码是可选项；
	用户可以在任意IP地址上登录
```

例如：

create user "test"@"localhost" identified by "1234";

CREATE USER 'john'@'192.168.189.71' IDENTIFIED BY "123";


#####1.3 然后登录一下：

mysql>exit;

@>mysql -u ruby -p

@>输入密码

mysql>登录成功

####2.为用户授权

```sql
授权格式：grant 权限 on 数据库.* to 用户名@登录主机 identified by "密码";
```

#####2.1 登录MYSQL（有ROOT权限），这里以ROOT身份登录：

@>mysql -u root -p

@>密码

#####2.2 首先为用户创建一个数据库(testDB)：

mysql>CREATE DATABASE`testDB`DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

#####2.3 授权test用户拥有testDB数据库的所有权限（某个数据库的所有权限）：

```sql
格式：grant 权限 on 数据库.* to 用户名@登录主机 identified by "密码";
```
例如：

mysql>grant all privileges on testDB.* to test@localhost identified by '1234';

mysql>flush privileges;//刷新系统权限表

#####2.4 如果想指定部分权限给一用户，可以这样来写:

例如：
mysql>grant select,update on testDB.* to test@localhost identified by '1234';

mysql>flush privileges; //刷新系统权限表

#####2.5 授权test用户拥有所有数据库的某些权限：

mysql>grant select,delete,update,create,drop on_._to test@"%" identified by "1234";

```
 //test用户对所有数据库都有select,delete,update,create,drop 权限。
```

//@"%" 表示对所有非本地主机授权，不包括localhost。（localhost地址设为127.0.0.1，如果设为真实的本地地址，不知道是否可以，没有验证。）

//对localhost授权：加上一句grant all privileges on testDB.* to test@localhost identified by '1234';即可。

#####3.撤销权限

```sql
revoke 权限1，权限2.。。。on 数据库.* from 用户名@IP地址;
```

撤销指定用户在指定数据库上的执行权限。

#####4.查看权限

```
show grants for 用户名@IP地址;
```

#####5.删除用户

@>mysql -u root -p

@>密码

删除账户及权限：>drop user 用户名@'%';

例如：
>drop user 用户名@ localhost;

## 三、MySQL 数据类型
MySQL中定义数据字段的类型对你数据库的优化是非常重要的。 MySQL支持多种类型，大致可以分为三类：数值、日期/时间和字符串(字符)类型。
### 3.1 数值类型
MySQL支持所有标准SQL数值数据类型。 这些类型包括严格数值数据类型(INTEGER、SMALLINT、DECIMAL和NUMERIC)，以及近似数值数据类型(FLOAT、REAL和DOUBLE PRECISION)。 关键字INT是INTEGER的同义词，关键字DEC是DECIMAL的同义词。 BIT数据类型保存位字段值，并且支持MyISAM、MEMORY、InnoDB和BDB表。 作为SQL标准的扩展，MySQL也支持整数类型TINYINT、MEDIUMINT和BIGINT。下面的表显示了需要的每个整数类型的存储和范围。

![1](media/15240479953131/1.png)

![2](media/15240479953131/2.png)


**在上面表中的类型中, 最常用的是2中类型: int(整数)和decimal(浮点数).**


### 3.2 日期和时间类型

表示时间值的日期和时间类型为DATETIME、DATE、TIMESTAMP、TIME和YEAR。 每个时间类型有一个有效值范围和一个"零"值，当指定不合法的MySQL不能表示的值时使用"零"值。 TIMESTAMP类型有专有的自动更新特性，将在后面描述。
![3](media/15240479953131/3.png)

**最常用: datatime类型.**

### 3.3 字符串类型

字符串类型指CHAR、VARCHAR、BINARY、VARBINARY、BLOB、TEXT、ENUM和SET。该节描述了这些类型如何工作以及如何在查询中使用这些类型。 CHAR和VARCHAR类型类似，但它们保存和检索的方式不同。它们的最大长度和是否尾部空格被保留等方面也不同。在存储或检索过程中不进行大小写转换。 BINARY和VARBINARY类类似于CHAR和VARCHAR，不同的是它们包含二进制字符串而不要非二进制字符串。也就是说，它们包含字节字符串而不是字符字符串。这说明它们没有字符集，并且排序和比较基于列值字节的数值值。 BLOB是一个二进制大对象，可以容纳可变数量的数据。有4种BLOB类型：TINYBLOB、BLOB、MEDIUMBLOB和LONGBLOB。它们只是可容纳值的最大长度不同。 有4种TEXT类型：TINYTEXT、TEXT、MEDIUMTEXT和LONGTEXT。这些对应4种BLOB类型，有相同的最大长度和存储需求。
![4](media/15240479953131/4.png)

**最常用的: char, varchar和text类型.**


> ** 总结常用的类型：**
>
>  int：整型
>
>  double：浮点型，例如double(5,2)表示最多5位，其中必须有2位小数，即最大值：999.99
>
>  decimal：浮点型，不会出现精度缺失问题，比如金钱。
>
>  char：固定长度字符串类型：最大长度：char(255)
>
>  varchar：可变长度字符串类型：最大长度：varchar(65535)
>
>  text(clob)：字符串类型，存储超大文本。
>
>  blob：字节类型，最大4G
>
>  date：日期类型，格式为：yyyy-MM-dd
>
>  time：时间类型：格式为：hh:mm:ss
>
>  timestamp：时间戳
>
>  datatime

## 四、表的基本操作
**数据库中存储的是表(table), 表中存储的是一行行的数据.**


### 4.1 查看当前数据库中的所有表
```sql
show tables;
```

### 4.2 创建表

通用语法：**CREATE TABLE table_****\*name (column_name column_type);**

```sql

CREATE TABLE [IF NOT EXISTS] 表名(
	列名 列类型(长度) 约束 默认值,
  	列名 列类型(长度) 约束 默认值,
  	...
); 

例如:
create table student(id int primary key auto_increament, name varchar(16) not null, age int, sex char(1));
```

在这里，一些数据项需要解释：

- 字段使用NOT NULL，是因为我们不希望这个字段的值为NULL。 因此，如果用户将尝试创建具有NULL值的记录，那么MySQL会产生错误。
- 字段的AUTO_INCREMENT属性告诉MySQL自动增加id字段下一个可用编号。
- DEFAULT 设置默认值。
- 关键字PRIMARY KEY用于定义此列作为主键。可以使用逗号分隔多个列来定义主键。


### 4.3 查看表结构

通用语法：**desc 表名;**

>describe tableName

### 4.4 查看表的创建语句

```sql
show create table 表名;
```
### 4.5 修改表

通用语法：**ALTER TALBE 表名....**

**1.添加字段** :add

```sql
alter table 表名 add(
	列名 列类型,
  	列名 列类型,
  	...
);
```

####4.5.1修改表

**2.修改列类型**:modify

```sql
alter table 表名 modify 
	列名 列类型;
```

注意：如果被修改的列已经存在数据，那么新的类型可能会影响到已存在的数据

**3.修改列名**:change

```sql
alter table 表名 change 
	原列名 新列名 列类型;
```

**4.删除列**:drop

```sql
alter table 表名 drop 
	列名;
```

**5.更改表的名称**:rename to

```sql
rename table 原表名 to 新表名;
alter table 原表名 rename to 
	新表名;
```
### 4.6 删除表

```sql
drop table [if exists] 表名;
```

### 4.7 [扩展]复制表中的数据(仅复制数据不复制表的结构)

```sql
create table 表名2 as select * from 表名1;
```

## 五、操纵表中的数据

对于数据表进行增删改查(也叫CRUD)。

DML语言：增删改

DQL语言：查

> crud是指在做计算处理时的增加(Create)、读取查询(Retrieve)、更新(Update)和删除(Delete)几个单词的首字母简写。crud主要被用在描述软件系统中数据库或者[持久层](https://baike.baidu.com/item/%E6%8C%81%E4%B9%85%E5%B1%82)的基本操作功能。

### 5.1 查询数据

查询数据的操作是最复杂, 后面专门细讲.
今天只使用最简单的.

```sql
select * from 表名;
```
### 5.1 查询数据

查询数据的操作是最复杂, 后面专门细讲.
今天只使用最简单的.

```sql
select * from 表名;
```
#### 5.2.1 全列插入

```sql
insert into 表名 values(值1, 值2,...);
```

说明:

1. 全列插入的时候需要每一列的数据都要添加上去.
2. 对自动增长的数据, 在全列插入的时候需要占位处理, 一般使用0来占位.但是最终的值以实际为准.

#### 5.2.2 缺省插入

```sql
insert into 表名(列1, 列2, ...) values(值1, 值2, ...);
```

说明:

1. 插入的时候,`not null`和`primary key`的列必须赋值, 其他的列根据情况来赋值.如果没有赋值则会使用默认值.

#### 5.2.3 同时插入多条数据

```sql
insert into 表名 values(值1, 值2,...), (值1, 值2,...),...;
```

或者

```sql
insert into 表名(列1, 列2, ...) values(值1, 值2, ...), (值1, 值2, ...), ...;
```


### 5.3 修改数据(更新数据)

```sql
update 表名 set 列1=值1,列2=值2,... where 条件
例如: 
update stus set sex='男',age=100 where sex is null;
```

>条件(条件是可选的)
>
>1. 条件必须是boolean类型的值或者表达式
>2. 运算符：=,!=,<>,>,<,>=,<=,between..and, in(...),or ,and ,not, is null，is not null
>3. is null 不是 = null(永远是false)

