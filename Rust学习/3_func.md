# Rust -- 函数

- 声明函数使用**fn**关键字
- 针对函数和变量名，使用snak case命名规范：
    - 所有的字母都是小写的，单词之间使用下划线分开：
示例：

```
fn another_func() {
    println!("another_func---")     
}

``` 

 
### 函数的参数

- 函数签名里面必须要有每个参数的类型

```rust
fn another_func_part(x:i32) {//parameter
    println!("another_func---x:--{}",x) 
}

fn main() {
    //argument
    another_func_part(5);
}
```

### 函数中的语句与表达式
- 函数由体系列语句组成，可选的由一个表达式结束
- `Rust`是一个基于表达式的语言，语句是执行一系列动作的指令
- 表达式会产生一个值
- 函数的定义也是语句
- 语句不返回值，所以不可以用**let**将一个语句赋值给一个变量
示例：

```
//let y =  (let x = 5); //错误展示

let y = {
    let x = 5;
    x + 3
}; //这是一个表达式

let y = {
    let x = 5;
    x + 3;
} //多了一个分号就变成了语句 因为默认的返回变成了()且会报错

```


### 函数的返回值

- 在**->**符号后面声明返回值的类型，但是不可以为返回值命名
- 在`Rust`里，返回值就是函数体里面最后一个表达式的值
- 若想提前返回，需要使用**return**关键字，并指定一个值
示例：

```
fn main() {
    let x = five();
    println!("x:---{}",x)
    let x = plus_five(6);
    println!("x:--plus_five-{}",x);
}

fn five() -> i32{
    5
}

fn plus_five(x :i32) -> i32 {
    x + 5
}
```

