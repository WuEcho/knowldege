# Rust

## 特性
- 高性能
- 内存安全
- 无忧并发(程序的开发)

### 内存安全
- 使用Rust(非unsafe部分)写出来的代码，保证内存安全
- 方法抉择：
    - Ownership,move语义
    - Borrowchecker
    - 强类型系统
    - 无空值（Null,nil等）设计

### 无忧并发 

- 使用`Rust`进行多线程以及多任务并发代码开发，不会出现数据竞争和临界值破
- 方法抉择
    - 对并发进行了抽象`Sync`,`Send`
    - 融入类型系统
    - 基于`Ownership`, `Borrowchecker`实现.完美的融合性

### 打开几个辅助网站

[https://play.rust-lang.org/?version=stable&mode=debug&edition=2021](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021)
[https://doc.rust-lang.org/std/index.html](https://doc.rust-lang.org/std/index.html)
[https://doc.rust-lang.org/book/title-page.html](https://doc.rust-lang.org/book/title-page.html)
[https://doc.rust-lang.org/rust-by-example/index.html](https://doc.rust-lang.org/rust-by-example/index.html)

## 1.安装
macOS, Linux, or another Unix-like OS.


```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 更新/卸载Rust


```
更新
-rustup update

卸载
-rustup self uninstall
```
### 验证


```
rustc --version
```

### 本地文档
安装rust的时候同步安装，可离线浏览，可用`rustup doc`浏览


### 编译

```
rustc xxx.rs
```
使用rustc进行编译适用于较小的rust程序

较大的rust程序编译需要使用cargo

### 模块组织形式

#### 形式1

```
backyard
├── Cargo.lock
├── Cargo.toml
└── src
 ├── garden
 │ └── vegetables.rs
 ├── garden.rs
 └── main.rs
```
 
#### 形式2

```
backyard
├── Cargo.lock
├── Cargo.toml
└── src
 ├── garden
 │ └── mod.rs
 │ └── vegetables.rs
 └── main.rs    //main.rs引入garden，会自动寻找mod.rs，进行加载
```

### Cargo

`cargo`是`rust`的包管理工具和构建系统，可以下载，构建依赖库构建代码，安装`rust`的时候就会安装`cargo`，验证是否安装使用`cargo --version`

#### Cargo.toml
rust语言对项目的配置文件

[https://doc.rust-lang.org/cargo/](https://doc.rust-lang.org/cargo/)
[https://github.com/hyperium/hyper/blob/master/Cargo.toml](https://github.com/hyperium/hyper/blob/master/Cargo.toml)

#### 使用cargo创建项目
- 创建项目：`cargo new hello_cargo`
项目名称是`hello_cargo`,会创建一个新的目录`hello_cargo`

- -- `Cargo.toml`
 
` cargo.toml`是`cargo`的配置格式
 
```
实例内容:

[package]  //[package] 是一个区域标题表示下方内容用来配置包（package）的
name = "hello_cargo"    //- name 项目名
version = "0.1.0"       //- version 版本号 
authors = ["----"]      //项目作者
edition = "2021"        //使用的Rust版本

[dependencies]          //[dependencies]另一个区域的开始会列出项目的依赖项

```
 
-  -- src目录
    - -- main.rs
    
    - cargo生成的main.rs在src目录下，而Cargo.tom在项目顶层下
    - 源代码都应在src目录下
    - 顶层目录可以放置：README,许可信息，配置文件及与程序源码无关的工作
    - 如果创建项目时没有使用cargo也可以把项目转化为使用cargo
    
- -- 初始化了一个新的git仓库，.gitignore
    

### 构建Cargo项目
 
- `cargo build`：

-- 创建而执行文件：`target/debug/hello_cargo`或`target/debug\hello_cargo.exe`
-- 运行可执行文件：`./target/debug/hello_cargo`或`.\target/debug\hello_cargo.exe`


- 第一次运行`cargo build`会在顶层目录生成`cargo.lock`文件，该文件负责追踪项目依赖的精确版本，无需手动修改

### 构建并运行cargo项目
`cargo run` 编译并运行代码


#### cargo check 
`cargo check` 检查代码，保证能通过编译但不产生任何执行文件

### 为发布构建
- `cargo build --release`
- 编译时会进行优化（代码运行的更快但是编译时间更长）
- 会在`target/release`中生成可执行文件



### 其他
- 1.cargo clippy：A collection of lints to catch common mistakes and improve your Rust code.
（[https://github.com/rust-lang/rust-clippy）](https://github.com/rust-lang/rust-clippy%EF%BC%89)

- 2.rust-analyzer：Bringing a great IDE experience to the Rust programming language.
（[https://rust-analyzer.github.io/）](https://rust-analyzer.github.io/%EF%BC%89)

- 3.Rust程序设计语言中文版 [https://kaisery.github.io/trpl-zh-cn/](https://kaisery.github.io/trpl-zh-cn/
)

- 4.Rust语言圣经  [https://course.rs/into-rust.html](https://course.rs/into-rust.html)

- 5.std文档 [https://doc.rust-lang.org/std/](https://doc.rust-lang.org/std/)

- 6.crates [https://crates.io/](https://crates.io/)

