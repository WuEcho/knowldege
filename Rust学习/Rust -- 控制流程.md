# Rust -- 控制流程


### if表达式

- if表达式允许根据条件来执行不同的代码分支，每个条件必是bool类型
- if表达式中，与条件相关的代码叫做分支（arm）
- 可选的，在后面加上一个else表达式 
示例：

```
   let b = 4;
   if b <= 5 {
       print!("小于的")
   } else {
       print!("大于的")
   }
```

- 如果使用多于一个else if,那么最好使用match来重构代码

 
- 在let语法中使用if
   因为if是个表达式，所以可以将他放在let语句中等号的右面
示例：

```rest
   let conmidity = true;

   let f = if conmidity {6} else {8};
   println!("f:---{}",f)
```   

### 循环

- loop :反复执行一块代码直到喊停
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
- while: 每次执行之前先判断条件,条件满足就继续执行

示例：

```
   let mut count = 4;
   while count != 0 {
      println!("count---{}",count);
      count -= 1; 
   }
``` 
- for：使用while和loop遍历集合效率低且易错，可使用for循环
示例：

```
   let a = [2,3,4,5];
   for element in a.iter() {
       println!("ele:--{}",element);
   }
``` 

- Range 
    - 标准库提供
    - 指定一个开始数字和一个结束数字，Range可以生成他们之间的数组（左包含右不包含）
    - rev方法反转Range
    - 语法：**..**,示例：(1..5)

示例：

```
for ele in (1..4).rev() {
       println!("ele--:{}",ele);
}

```


