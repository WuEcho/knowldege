# redis数据结构



##1.redis列表（List）
  单键多值redis列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。它的底层实际上是使用双向链表实现的，对两端的操作性能很高，通过索引下标操作中间节点性能会较差。

###1.1 常用命令

**lpush/rpush：从左边或者右边插入一个或多个值**

```
lpush/rpush <key1> <value1> <key2> <value2> ...
```

示例

```
> flushdb #清空db，方便测试 
OK
> rpush name java spring "springboot" "spring cloud" #列表name的左边 插入4个元素
(integer) 4 
> lrange name 1 2 #从左边取出索引位于[1,2]范围内的元素 
1) "spring" 
2) "springboot
> lrange name 1 3
1) "spring"
2) "springboot"
3) "spring cloud"
```

**lrange：从列表左边获取指定范围内的值**

```
lrange <key> <star> <stop>

返回列表 key 中指定区间内的元素，区间以偏移量 start 和 stop 指定。
下标(index)参数 start 和 stop 都以 0 为底，也就是说，以 0 表示列表的第一个元素，以 1
表示列表的第二个元素，以此类推。
你也可以使用负数下标，以 -1 表示列表的最后一个元素， -2 表示列表的倒数第二个元素，以此类推。

返回值:
一个列表，包含指定区间内的元素。
```
示例

```
127.0.0.1:6379> rpush course java c c++ php js nodejs
(integer) 6
127.0.0.1:6379> lrange course 0 -1
1) "java"
2) "c"
3) "c++"
4) "php"
5) "js"
6) "nodejs"
127.0.0.1:6379> lrange course 0 3
1) "java"
2) "c"
3) "c++"
4) "php"
```

**lpop/rpop：从左边或者右边弹出多个元素**


```
lpop/rpop <key> <count>

count：可以省略，默认值为1
lpop/rpop 操作之后，弹出来的值会从列表中删除
值在键在，值亡键亡。
```
示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> rpush k1 1 2 3 #列表k1的右边添加3个元素[1,2,3] 
(integer) 3 
127.0.0.1:6379> lrange k1 0 -1 #从左到右输出k1列表中的元素 
1) "1" 
2) "2" 
3) "3" 
127.0.0.1:6379> rpush k2 4 5 6 #列表k2的右边添加3个元素[4,5,6] 
(integer) 3 
127.0.0.1:6379> lrange k2 0 -1 #从左到右输出k2列表中的元素 
1) "4" 
2) "5" 
3) "6" 
127.0.0.1:6379> rpoplpush k1 k2 #从k1的右边弹出一个元素放到k2的左边 
"3" 
127.0.0.1:6379> lrange k1 0 -1 #k1中剩下2个元素了 
1) "1" 
2) "2" 
127.0.0.1:6379> lrange k2 0 -1 #k2中变成4个元素了
1) "3" 
2) "4" 
3) "5" 
4) "6"
```

**lindex：获取指定索引位置的元素（从左到右）**

```
lindex key index

返回列表 key 中，下标为 index 的元素。
下标(index)参数 start 和 stop 都以 0 为底，也就是说，以 0 表示列表的第一个元素，以 1 表示列表的第二个元素，以此类推。
你也可以使用负数下标，以 -1 表示列表的最后一个元素， -2 表示列表的倒数第二个元素，以此类推。
如果 key 不是列表类型，返回一个错误。

返回值:
列表中下标为 index 的元素。
如果 index 参数的值不在列表的区间范围内(out of range)，返回 nil
```
示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> rpush course java c c++ php #列表course中放入4个元素
(integer) 4 
127.0.0.1:6379> lindex course 2 #返回索引位置2的元素 
"c++" 
127.0.0.1:6379> lindex course 200 #返回索引位置200的元素，没有 
(nil) 
127.0.0.1:6379> lindex course -1 #返回最后一个元素
"php"
```

**llen：获得列表长度**

```
llen key

返回列表 key 的长度。
如果 key 不存在，则 key 被解释为一个空列表，返回 0 .
如果 key 不是列表类型，返回一个错误。
```

示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> rpush name ready tom jack 
(integer) 3 
127.0.0.1:6379> llen name
(integer) 3
127.0.0.1:6379> rpush name sam json
(integer) 5
127.0.0.1:6379> llen name
(integer) 5
```

**linsert：在某个值的前或者后面插入一个值**

```
linsert <key> before|after <value> <newvalue>

将值 newvalue 插入到列表 key 当中，位于值 value 之前或之后。
当 value 不存在于列表 key 时，不执行任何操作。
当 key 不存在时， key 被视为空列表，不执行任何操作。
如果 key 不是列表类型，返回一个错误。

返回值:
如果命令执行成功，返回插入操作完成之后，列表的长度。
如果没有找到 value ，返回 -1 。
如果 key 不存在或为空列表，返回 0 。
```

示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> rpush name ready tom jack #列表name中添加3个元素 
(integer) 3 
127.0.0.1:6379> lrange name 0 -1 #name列表所有元素
1) "ready" 
2) "tom" 
3) "jack" 
127.0.0.1:6379> linsert name before tom lily #tom前面添加lily 
(integer) 4 
127.0.0.1:6379> lrange name 0 -1 #name列表所有元素 
1) "ready" 
2) "lily" 
3) "tom" 
4) "jack" 
127.0.0.1:6379> linsert name before xxx lucy # 在元素xxx前面插入lucy，由于xxx元素不存 在，插入失败，返回-1 
(integer) -1 
127.0.0.1:6379> lrange name 0 -1 
1) "ready" 
2) "lily" 
3) "tom" 
4) "jack"
```

**lrem：删除指定数量的某个元素**

```
LREM key count value

根据参数 count 的值，移除列表中与参数 value 相等的元素。
count 的值可以是以下几种：
 - count > 0 : 从表头开始向表尾搜索，移除与 value 相等的元素，数量为 count 。 
 - count < 0 : 从表尾开始向表头搜索，移除与 value 相等的元素，数量为 count 的绝对
值。
 - count = 0 : 移除表中所有与 value 相等的值。

返回值：
被移除元素的数量。
因为不存在的 key 被视作空表(empty list)，所以当 key 不存在时，总是返回 0 。
```

示例

```
127.0.0.1:6379> flushdb #清空db，方便测试 
OK
127.0.0.1:6379> rpush k1 v1 v2 v3 v2 v2 v1 #k1列表中插入6个元素 
(integer) 6 
127.0.0.1:6379> lrange k1 0 -1 #输出k1集合中所有元素 
1) "v1" 
2) "v2"  
3) "v3" 
4) "v2" 
5) "v2"
6) "v1" 
127.0.0.1:6379> lrem k1 2 v2 #k1集合中从左边删除2个v2 
(integer) 2 
127.0.0.1:6379> lrange k1 0 -1 #输出列表，列表中还有1个v2，前面2个v2干掉了 
1) "v1" 
2) "v3" 
3) "v2" 
4) "v1"
```

**lset：替换指定位置的值**


```
lset <key> <index> <value>

将列表 key 下标为 index 的元素的值设置为 value 。 当 index 参数超出范围，或对一个空列表( key 不存在)进行lset时，返回一个错误。
返回值：
操作成功返回 ok ，否则返回错误信息。
```

示例

```
127.0.0.1:6379> flushdb #清空db，方便测试 
OK
127.0.0.1:6379> rpush name tom jack ready #name集合中放入3个元素 
(integer) 3 
127.0.0.1:6379> lrange name 0 -1 #输出name集合元素 
1) "tom" 
2) "jack" 
3) "ready" 
127.0.0.1:6379> lset name 1 lily #将name集合中第2个元素替换为liy 
OK
127.0.0.1:6379> lrange name 0 -1 #输出name集合元素 
1) "tom" 
2) "lily" 
3) "ready" 
127.0.0.1:6379> lset name 10 lily #索引超出范围，报错
(error) ERR index out of range
```

##2.redis集合（Set）

   redis set对外提供的功与list类似，是一个列表的功能，特殊之处在于set是可以自动排重的，当你需要存储一个列表数据，又不希望出现重复数据时，set是一个很好的选择。
   redis的set是string类型的无序集合，他的底层实际是一个value为null的hash表，收益添加，删除，查找复杂度都是O(1)。

###2.1 常用命令

**sadd：添加一个或多个元素**

```
sadd <key> <value1> <value2> ...
```
示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> sadd k1 v1 v2 v1 v3 v2 #k1中放入5个元素，会自动去重，成功插入3个 (integer) 3
```

**smembers：取出所有元素**

```
smembers <key>
```
示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> sadd k1 v1 v2 v1 v3 v2 
(integer) 3 
127.0.0.1:6379> smembers k1 
1) "v2" 
2) "v1" 
3) "v3"
```
**sismember：判断集合中是否有某个值**

```
sismember <key> <value>
判断集合key中是否包含元素value，1：有，0：没有
```
示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> sadd k1 v1 v2 v1 v3 v2 #k1集合中成功放入3个元素[v1,v2,v3] 
(integer) 3 
127.0.0.1:6379> sismember k1 v1 #判断k1中是否包含v1，1：有 
(integer) 1 
127.0.0.1:6379> sismember k1 v5 #判断k1中是否包含v5，0：无
(integer) 0
```

**scard：返回集合中元素的个数**

```
scard <key>

返回集合 key 的基数(集合中元素的数量)

返回值：
集合的基数。
当 key 不存在时，返回 0 。
```

示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> sadd k1 v1 v2 v1 v3 v2 
(integer) 3 
127.0.0.1:6379> scard k1 
(integer) 3
```

**srem：删除多个元素**

```
srem key member [member ...]

移除集合 key 中的一个或多个 member 元素，不存在的 member 元素会被忽略。
当 key 不是集合类型，返回一个错误。

返回值:
被成功移除的元素的数量，不包括被忽略的元素
```

示例

```
127.0.0.1:6379> flushdb #清空db，方测试 
OK127.0.0.1:6379> sadd course java c c++ python #集合course中添加4个元素 
(integer) 4 
127.0.0.1:6379> smembers course #获取course集合所有元素 
1) "python" 
2) "java" 
3) "c++" 
4) "c" 
127.0.0.1:6379> srem course java c #删除course集合中的java和c 
(integer) 2 
127.0.0.1:6379> smembers course #获取course集合所有元素，剩下2个了 
1) "python" 
2) "c++"
```

**spop：随机弹出多个值**

```
spop <key> <count>

随机从key集合中弹出count个元素，count默认值为1

返回值:
被移除的随机元素。
当 key 不存在或 key 是空集时，返回 nil
```

示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> sadd course java c c++ python #course集合中添加4个元素 
(integer) 4 
127.0.0.1:6379> smembers course #获取course集合中所有元素 
1) "python" 
2) "java" 
3) "c++" 
4) "c" 
127.0.0.1:6379> spop course #随机弹出1个元素，被弹出的元素会被删除 
"c++" 
127.0.0.1:6379> spop course 2 #随机弹出2个元素 
1) "java" 
2) "python"
```

**srandmember：随机获取多个元素，不会从集合中删除**

```
srandmember <key> <count>

从key指定的集合中随机返回count个元素，count可以不指定，默认值是1。
srandmember 和 spop的区别：
都可以随机获取多个元素，srandmember 不会删除元素，而spop会删除元素。

返回值:
只提供 key 参数时，返回一个元素；如果集合为空，返回 nil 。
如果提供了 count 参数，那么返回一个数组；如果集合为空，返回空数组。
```
示例

```
127.0.0.1:6379> flushdb #清空db，方便测试
OK
127.0.0.1:6379> sadd course java c c++ python #course中放入5个元素
(integer) 4 
127.0.0.1:6379> smembers course #输出course集合中所有元素 
1) "python" 
2) "java" 
3) "c++" 
4) "c" 
127.0.0.1:6379> srandmember course 3 #随机获取3个元素，元素并不会被删除 
1) "python" 
2) "c++" 
3) "c" 
127.0.0.1:6379> smembers course #输出course集合中所有元素，元素个数未变 
1) "python" 
2) "java" 
3) "c++" 
4) "c"
```

**smove：将某个原创从一个集合移动到另一个集合**

```
smove <source> <destination> member

将 member 元素从 source 集合移动到 destination 集合。
smove 是原子性操作。
如果 source 集合不存在或不包含指定的 member 元素，则 smove 命令不执行任何操作，仅返回 0 。否则， member 元素从 source 集合中被移除，并添加到 destination 集合中去。
当 destination 集合已经包含 member 元素时，smove 命令只是简单地将 source 集合中的member 元素删除。
当 source 或 destination 不是集合类型时，返回一个错误。

返回值:
如果 member 元素被成功移除，返回 1 。
如果 member 元素不是 source 集合的成员，并且没有任何操作对 destination 集合执行，那么返回 0 。
```

示例

```
127.0.0.1:6379> flushdb #清空db，方便测试 
OK
127.0.0.1:6379> sadd course1 java php js #集合course1中放入3个元素[java,php,js] (integer) 3 
127.0.0.1:6379> sadd course2 c c++ #集合course2中放入2个元素[c,c++] 
(integer) 2 
127.0.0.1:6379> smove course1 course2 js #将course1中的js移动到course2 
(integer) 1 
127.0.0.1:6379> smembers course1 #输出course1中的元素 
1) "java" 
2) "php" 
127.0.0.1:6379> smembers course2 #输出course2中的元素 
1) "js" 
2) "c++" 
3) "c"
```

**sinter：取多个集合的交集**

```
sinter key [key ...]
```
示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> sadd course1 java php js #集合course1：[java,php,js]
(integer) 3 
127.0.0.1:6379> sadd course2 c c++ js #集合course2：[c,c++,js] 
(integer) 3 
127.0.0.1:6379> sadd course3 js html #集合course3：[js,html] 
(integer) 2 
127.0.0.1:6379> sinter course1 course2 course3 #返回三个集合的交集，只有：[js] 
1) "js"
```

**sinterstore：将多个集合的交集放到一个新的集合中**

```
sinterstore destination key [key ...]

这个命令类似于 sinter 命令，但它将结果保存到 destination 集合，而不是简单地返回结果集。

返回值:
结果集中的成员数量。
```

**sunion：取多个集合的并集，自动去重**

```
sunion key [key ...]
```
示例

```
127.0.0.1:6379> sadd course1 java php js #集合course1：[java,php,js] 
(integer) 3 
127.0.0.1:6379> sadd course2 c c++ js #集合course2：[c,c++,js] 
(integer) 3 
127.0.0.1:6379> sadd course3 js html #集合course3：[js,html] 
(integer) 2 
127.0.0.1:6379> sunion course1 course2 course3 #返回3个集合的并集，会自动去重 
1) "php" 
2) "js" 
3) "java" 
4) "html" 
5) "c++" 
6) "c"
```

**sunionstore：将多个集合的并集放到一个新的集合中**

```
sinterstore destination key [key ...]

这个命令类似于 sunion 命令，但它将结果保存到 destination 集合，而不是简单地返回结果
集。

返回值:
结果集中的成员数量
```

**sdiff：取多个集合的差集**

```
SDIFF key [key ...]

返回一个集合的全部成员，该集合是所有给定集合之间的差集。
不存在的 key 被视为空集
```
示例

```
127.0.0.1:6379> flushdb 
OK
127.0.0.1:6379> sadd course1 java php js #集合course1：[java,php,js] 
(integer) 3 
127.0.0.1:6379> sadd course2 c c++ js #集合course2：[c,c++,js] 
(integer) 3 
127.0.0.1:6379> sadd course3 js html #集合course3：[js,html] 
(integer) 2 
127.0.0.1:6379> sdiff course1 course2 course3 #返回course1中有的而course2和course3 中都没有的元素 
1) "java" 
2) "php
```

**sdiffstore：将多个集合的差集放到一个新的集合中**

```
sdiffstore destination key [key ...]

这个命令类似于 sdiff 命令，但它将结果保存到 destination 集合，而不是简单地返回结果集。

返回值:
结果集中的成员数量
```
##redis Hash

