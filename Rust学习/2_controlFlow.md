# Rust -- 控制流程


### if表达式

- `if`表达式允许根据条件来执行不同的代码分支，每个条件必是`bool`类型
- `if`表达式中，与条件相关的代码叫做分支（`arm`）
- 可选的，在后面加上一个`else`表达式 
示例：

```
   let b = 4;
   if b <= 5 {
       print!("小于的")
   } else {
       print!("大于的")
   }
```

- 如果使用多于一个`else if`,那么最好使用`match`来重构代码


```
 if number % 4 == 0 {
    println!("number is divisible by 4");
 } else if number % 3 == 0 {
    println!("number is divisible by 3");
 } else if number % 2 == 0 {
    println!("number is divisible by 2");
 } else {
    println!("number is not divisible by 4, 3, or 2");
 }
```
 
- 在`let`语法中使用`if`
   因为`if`是个表达式，所以可以将他放在`let`语句中等号的右面
  
 另外，如果在`if-else`语句块里的值没有`;`则会将这个值当成返回值进行返回 
   
示例：

```rest
   let conmidity = true;

   let f = if conmidity {6} else {8};
   println!("f:---{}",f)
   
   let x = 1;
   let y = if y == x {
        100
   }else{
        101
   }  
```   

### 循环

#### Loop
- `loop` :反复执行一块代码直到喊停
    - 可以在loop循环中使用break关键字来告诉程序何时停止
示例：

``` 
   let mut counter = 0;
   let result = loop {
       counter +=1;
       if counter == 10 {
           break counter * 2;
       }
   };
   println!("result ---{}",result)
```
#### While 

- `while`: 每次执行之前先判断条件,条件满足就继续执行

示例：

```
   let mut count = 4;
   while count != 0 {
      println!("count---{}",count);
      count -= 1; 
   }
``` 

#### for
- `for`：使用`while`和`loop`遍历集合效率低且易错，可使用`for`循环
示例：

```
   let a = [2,3,4,5];
   for element in a.iter() {
       println!("ele:--{}",element);
   }
``` 

#### Range

- `Range` 
    - 标准库提供
    - 指定一个开始数字和一个结束数字，`Range`可以生成他们之间的数组（左包含右不包含）,如果想包含右侧则`..=`
    - `rev`方法反转`Range`
    - 语法：**..**,示例：(1..5)

示例：

```
for ele in (1..=4) {
       println!("ele--:{}",ele);
}


for ele in (1..4).rev() {
       println!("ele--:{}",ele);
}

```

[Range文档链接](https://doc.rust-lang.org/std/ops/struct.Range.html)

