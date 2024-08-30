# Rust

##1.安装
macOS, Linux, or another Unix-like OS.


```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

###更新/卸载Rust


```
更新
-rustup update

卸载
-rustup self uninstall
```
###验证


```
rustc --version
```

###本地文档
安装rust的时候同步安装，可离线浏览，可用`rustup doc`浏览


###编译

```
rustc xxx.rs
```
使用rustc进行编译适用于较小的rust程序

较大的rust程序编译需要使用cargo

###Cargo

cargo是rust的包管理工具和构建系统，可以下载，构建依赖库构建代码，安装rust的时候就会安装cargo，验证是否安装使用`cargo --version`

####使用cargo创建项目
- 创建项目：cargo new hello_cargo
项目名称是hello_cargo,会创建一个新的目录hello_cargo
 -- Cargo.toml
 
 cargo.toml是cargo的配置格式
 
```
实例内容:

[package]  //[package] 是一个区域标题表示下方内容用来配置包（package）的
name = "hello_cargo"    //- name 项目名
version = "0.1.0"       //- version 版本号 
authors = ["----"]      //项目作者
edition = "2021"        //使用的Rust版本

[dependencies]          //[dependencies]另一个区域的开始会列出项目的依赖项

```
 
 -- src目录
    -- main.rs
    
    - cargo生成的main.rs在src目录下，而Cargo.tom在项目顶层下
    - 源代码都应在src目录下
    - 顶层目录可以放置：README,许可信息，配置文件及与程序源码无关的工作
    - 如果创建项目时没有使用cargo也可以把项目转化为使用cargo
    
 -- 初始化了一个新的git仓库，.gitignore
    

 ###构建Cargo项目
 
- cargo build：

-- 创建而执行文件：target/debug/hello_cargo或target/debug\hello_cargo.exe
-- 运行可执行文件：./target/debug/hello_cargo或.\target/debug\hello_cargo.exe


- 第一次运行cargo build会在顶层目录生成cargo.lock文件，该文件负责追踪项目依赖的精确版本，无需手动修改

###构建并运行cargo项目
cargo run 编译并运行代码


####cargo check 
cargo check 检查代码，保证能通过编译但不产生任何执行文件

###为发布构建
- cargo build --release
- 编译时会进行优化（代码运行的更快但是编译时间更长）
- 会在target/release中生成可执行文件


