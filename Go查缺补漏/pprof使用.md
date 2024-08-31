
# pprof使用--golang性能调优工具

url：https://blog.csdn.net/hzb869168467/article/details/136276023


pprof是golang官方提供的性能测评工具，包含在net/http/pprof和runtime/pprof两个包中，分别用于不同场景。

runtime/pprof主要用于可结束的代码块，如一次编解码操作等； net/http/pprof是对runtime/pprof的二次封装，主要用于不可结束的代码块，如web应用等。

首先利用runtime/pprof进行性能测评，下列代码主要实现循环向一个列表中append一个元素，只要导入runtime/pprof并添加2段测评代码就可以实现cpu和mem的性能评测。

### 如何启动CPU采样

```
import (
    "runtime/pprof"
    "os"
)

func main() {
    // 启动CPU性能分析，每秒采样100次
    pprof.StartCPUProfile(os.Stdout)
    defer pprof.StopCPUProfile()
    // ... 执行程序逻辑 ...
}

```

go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30

### 如何启动Goroutine采样

```
import (
    "runtime/pprof"
)

func main() {
    // 获取当前所有Goroutine的堆栈信息
    pprof.Lookup("goroutine").WriteTo(os.Stdout, 1)
    // ... 执行程序逻辑 ...
}

```


### 如何启动内存采样


```
import (
    "runtime/pprof"
)

func main() {
    // 设置内存分配采样率，每分配512KB内存进行一次采样
    runtime.MemProfileRate = 512 * 1024

    // ... 执行程序逻辑 ...
    // 停止内存分配采样
    pprof.Lookup("allocs").WriteTo(os.Stdout, 1)
}

```

go tool pprof http://localhost:6060/debug/pprof/heap


### 如何启动阻塞和锁竞争采样


```
import (
    "runtime/pprof"
)

func main() {
    // 获取阻塞操作的采样信息
    pprof.Lookup("block").WriteTo(os.Stdout, 1)
    // ... 执行程序逻辑 ...
}

```

阻塞分析：go tool pprof http://localhost:6060/debug/pprof/block


### 如何生成火焰图


```
go tool pprof -pdf cpu.prof > flamegraph.pdf

```
这个命令会将火焰图输出到一个PDF文件中。你也可以使用-svg​或-web​参数来生成SVG文件或直接在Web浏览器中打开。


图形化工具：
go tool pprof -http=localhost:8080 cpu.prof


### top：列出数据
要列出当前资源的占用情况，可以在 pprof 中使用 top 命令：



### list：显示详情

当发现某个函数资源占用情况可疑时，可以通过 list 函数名 定位到具体的代码位置



打开某个代码生成的文件：
go tool pprof /Users/wuxinyang/pprof/


go tool pprof http://localhost:6060/debug/pprof/allocs 

