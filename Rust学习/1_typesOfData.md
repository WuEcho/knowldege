# Rust -- 变量，常量与数据类型

## 常量
- 常量在绑定值以后是不可变的，且与不可变变量有诸多区别：
    - 不可用`mut`
    - 声明常量使用**const**且类型必须被标注 
    - 常量可在任何作用域内进行声明，包括全局作用域
    - 常量只可绑定到常量表达式，无法绑定绑定到函数的调用结果或只能在运行时才能计算的值
- 在程序运行期间，常量在其声明的作用域内一直有效
- 命名规范：`rust`里常量使用全大写字母，每个单词之间用下划线分开，例如：`MAX_POINTS`    

示例：`const MAX_POINTS:u32 = 100_000`;

## 变量
### 不可变变量
使用关键字**let**声明一个变量默认情况下，这个变量就是不可变的，示例;

```rust
let x(:i32 --代码编辑器上默认会给x添加上一个数据类型i32)= 5;
println!("This value x value is :{}",x);
x = 6;
println!("This value x value is :{}",x);
//编译的时候会报错：cannot assign twice to immutable variable
```

### 可变变量
在**let**关键字后面使用关键字**mut**来声明这个变量是可变的，示例：

```rust
let mut x = 5;
x = 6;
println!("This value x value is :{}",x); //编译无报错
```

### Shadowing（隐藏）
- 可以使用相同的名字声明新的变量，新的变量会`shadow`（隐藏）之前声明的同名变量
    - 在后续的代码中这个变量名代表的就是新的变量
示例：
    
```rust
let x = 5;
x = x + 1;
//以上会报错

//一下不会报错
let x = 5;
let x = x + 1; //本行代码x隐藏了上面声明的x
```

- `shadow`和把变量标记为`mut`是不一样的：
    - 如果不使用**let**关键字，那么重新给非`mut`的变量赋值会导致编译时错误
    - 使用**let**声明的同名新变量也是不可变的
    - 使用**let**声明的同名新变量，它的类型可以与之前不同

示例：

```rust
let str = "  ";
let str = str.len();
println!("str value is :{}",str);
```

### 下划线`-`
下划线`_`是一个特殊的名称-或者更确切地说，是“缺省名称”。以下划线开头的名称是常规名称，编译器不会警告他们未使用。

```
let _x = 42;
```


## 数据类型

- `标量`和`复合类型`
- `Rust`是静态编译语言，在编译的时候**必须知道变量的类型**
    - 基于使用的值，编译器通常能够推断出他的具体类型
    - 如果类型比较多（如把`string`转为整数的`parse`方法），就必须`添加类型的标注`   

### 标量

- 一个标量类型代表一个单一的值
- `Rust`有四个主要的标量类型：

#### 整数类型

- 整数类型没有小数部分
- 无符号整数类型以`u`开头
- 有符号整数类型以`i`开头
- rust的整数类型列表如下
    
    | length | signed | unsigned |
    | --- | --- | --- |
    | 8-bit | i8 | u8 |
    | 16-bit | i16 | u16 |
    | 32-bit | i32 | u32 |
    | 64-bit | i64 | u64 |
    | 128-bit | i128 | u128 |
    | arch | isize | usize |
    | 取值范围 | -(2^n -1) ~ 2^n-1 -1 | 0 ~ 2^n -1 |
    
##### isize和usize
- `isize`和`usize`类型的位数由程序运行的计算机的架构决定：如果是64位计算机，那就是64位
##### 整数字面值
- 除了`byte`类型外，所有的数值字面值都允许使用类型后缀。如：`57u8`
- 整数的默认类型就是`i32`
 
    | number literals | example |
    | --- | --- |
    | decimal | 98_222(这里是用下划线是增加可读性) |
    | hex | 0xff |
    | Octal | 0o77 |
    | binary | 0b111_000 |
    | Byte(u8 only) | b'A' |
    
##### 整数溢出

- 调试模式下编译：`rust`会检查整数溢出，如果发生溢出，程序在运行时会`panic`
- 发布模式下（--release）编译：`rust`不会检查可能导致panic的整数溢出，如果溢出发生`rust`会执行**环绕**逻辑：例如：u8取值范围0-255，256变成0，257变成1...,且不会panic
   


#### 浮点类型
- `rust` 有两种基础的浮点类型，也就是含有小数点部分的类型
        - `f32`，32位，单精度
        - `f64`，64位，双精度 
- `rust`的浮点数类型使用了`ieee-754`标准来表述
- `f64`是默认类型，现在`cpu`上`f64`和`f32`的速度差不多，而且精度更高 
 
#### 布尔类型
- 有两个值：`true`和`false` 
- 占一个字节大小
- 符号是`bool`
 
#### 字符类型 
- `rust`语言中`char`类型被用来描述语言中最基础的单个字符
- 字符类型的字面值使用单引号
- 占用`4`字节大小


```
let c = 'z';
  
```

### 字符串String
`String`内部存储的`Unicode`字符串的`UTF8`编码。


```
let s = String::from("initial contents");
let hello = String::from("你好");
```

**字符串不能使用索引操作**
**注意：**`Rust`中的`String`不能通过下标去访问：
错误示范
```
let hello = String::form("你好");
lat a = hello[0]; //可能想把“你”取出来，但实际上这样是错误的
```
因为`String`存储的`UTF8`编码，这样访问即使成功，也只能取出一个字符的`UTF8`编码的一部分，没有意义。因此`Rust`直接对`String`禁止了索引操作。错误信息如下：

```
error[E0277]: the type `String` cannot be indexed by `{integer}`
```

#### 原始字符串字面量
一种特殊的字符串表示方式，用于避免转义字符，允许字符串中包含特殊符号或复杂内容（如反斜杠和引号），而无需担心这些符号被错误地解释为转义字符。

- 语法：原始字符串字面量使用 `r#` 开头，并以 `#` 结束：

```
let s = r#"This is a "raw" string with special characters: \n, \t"#;
```

在上面的例子中：
   
   - 使用`r#"..."#`定义字符串，可以包含`双引号`、`反斜杠`和`其他特殊字符`，而`不需要转义`。
   - 引号内的内容将原样保持，不会对`\n、\t`等字符进行转义处理。

- 如果字符串本身包含`#`符号，可以在`r`和字符串之间加更多的`#`符号来处理：

```
let s = r##"This string contains a "#", so we use more "##;

```

#### 将字符串转换成字符数组
String => [char]



### 复合类型
- 复合类型可以将多个值放在一个类型里面。
- `rust`提供了两种基础的复合类型：元组（`Tuple`）,数组

#### Tuple元组
- `Tuple`可以将多个类型的多个值放在一个类型里
- `Tuple`的长度是固定的：一旦声明就无法改变

##### 创建Tuple 
 
- 在小括号里，将值用逗号分开
示例：

```rust
 let tup:(u32,f32,i32) = (1,2.3,5);
```

- `Tuple`中的每个位置都对应一个类型，`Tuple`中各元素的类型不必相同


##### 获取Tuple的元素值-解构元组
- 可以使用模式匹配来解构（`destructure`）一个`Tuple`来获取元组的值
示例：

```rust
    //Tuple
    let tup:(u32,f32,i32) = (1,2.3,5);
    println!("0:---{};1:---{},2:---{}",tup.0,tup.1,tup.2);

    //destructure

    let (x,y,z) = tup;
    println!("x:{},y:{},z:{}",x,y,z);
```

- 解构元组时，`-`可以用来忽略元组的一部分 


```
let (_,right) = slice.split_at(middle);
```

##### 访问Tuple的元素
- 在`Tuple`变量使用点标记法，后接元素的索引号


#### 数组
- 数组可以将多个值放在一个类型里
- 数组中每个元素的类型必须相同
- 数组长度也是固定的
- 可使用下表访问数组 

##### 声明数组
- 在中括号里，各值用逗号分开
示例：

```rust
let arr=[1,2,3];
```

- 如果数组的每个元素值都相同，那么可以：
    - 中括号里指定初始值，然后是一个`“;”`，最后是数组长度
示例：

```
let a = [3;5];
```
     
 
##### 数组用处
- 如果想让数据存放在`stack`(栈)上不是`heap`上，或者想保证有固定数量的元素，这时使用数组更有好处
- 数组没有`Vector`灵活


##### 数组的类型

###### 定长数组
- 表示形式：`[类型：长度]` 示例：` let a:[i32:5] = [1,2,3,4,5];`

###### 动态数组
- 语法： 
    - 1.创建空动态数组`Vec<T>`
    - 2.使用`vec!`宏
示例：

```
//1.
let v:Vec<i32> = Vec::new();

//2.
let v = vec![1,2,3,4,5]; 
```

- 操作
    - 添加元素，`push()`
    - 获取长度，`.len()`
    - 移除元素，`.pop()`

    
```
//示例
let mut v = Vec::new();
v.push(10);
v.push(20);

let len = v.len();  // 返回动态数组的长度

let third = &v[2];  // 索引从0开始，访问第3个元素

v.pop();  // 移除最后一个元素，返回值是一个Option类型

for i in &v {
    println!("{}", i);
}
```

##### 访问数组元素
- 数组是`stack`上分配的单个块内存
- 可以使用索引来访问数组的元素，示例：

```
let arr=[1,2,3];
println!("arr---{}",arr[0]);
```

- 如果访问的索引超出了数组的范围，那么：1.编译通过，运行时报错


#### Hash表

可以通过官网查doc进行查询，链接：[https://doc.rust-lang.org/std/index.html](https://doc.rust-lang.org/std/index.html)


```
use std::collections::HashMap;
fn main() {
    let mut scores = HashMap::new();
    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);
    println!(“{:?}”, scores);
}
```

#### 结构体
- 语法：

```
struct v{
   valueName1 : Type,
   valueName2 : Type,
}
```
示例：

```
#[derive(Debug)]   //此处的[derive(Debug)] 适用于在打印的时候的标记，没有这个无法打印结构体内容
struct User {
    active:bool,
    userName:String,
    email:String,
    age:u32,
}

fn main() {
    
    let u = User {
        active:true,
        userName:String::from("li"),
        email:String::from("xxxx@email.com"),
        age:16,
    };
    
    println!("{:?} {}",u,u.active);
}```

#### 枚举

```
enum IpAddrKind {
    V4,
    V6,
}

let four = IpAddrKind::V4;
let six = IpAddrKind::V6;
```
**注意**`rust`中的枚举与go语言中的枚举并不相同的点在于他不会给枚举的值进默认赋值操作以及自动累加的过程


