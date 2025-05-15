 # go语言查缺补漏


### 通过反射访问私有变量

```
pkg main

type Person {
    name string
    age int
}


func main() {
   p := Person{name :"json",age:12} 
   //获取指针的反射值  Elem()获取指针指向的值
   v := reflect.ValueOf(&p).Elem()
   //获取字段
   namdField := v.FieldByName(“name")
   
   //使用反射和unsafe.pointer 和反射来获取
 namdField =  reflect.NewAt(field.Type(),unsafe.Pointer(namdField.UnsafeAddr())).Elem()
    //namdField.String()   
}
```

### 闭包


```
func adder() func(x int) int {
       var sum = 0
        return func(x int) int {
            sum += x
            return sum
        }
}

```


### defer快照失效的情况

defer的变量快照是指defer语句在定义时所捕获的变量状态，在如下状态下会失效：
1.匿名函数闭包， 2.引用类型


### init
init()函数在程序启动时运行，程序启动时程序的执行顺序为：包导入，变量初始化，inint()函数启动，main函数启动

### rune类型

rune类型用来表示Unicode码点的。它本质上是int32类型的别名，用来方便处理和表示字符

### 打印字符串%v和%+v的区别

区别在于打印结构体的效果不同

- 1.**%v**适用于打印变量的值，打印结构体时，只会显示字段的值而不显示名字

- 2.**%+v**适用于详细打印结构体的内容包括名字和值

ps :**%d**,**%f**,**%s**这些用于打印整数，字符串和浮点数，**%q**打印带引号的字符串或带引号的字符

### 枚举
使用const常量和iota枚举起来实现类似枚举值的效果：如：

```
const (
       Unknow = 0 
       Draft  = 1 
)
//或
const (
       Unknow = iota 
       Draft  
)
```

### 自定义类型切片与字节切片互转

涉及**encoding/binary**包的操作的序列化和反序列化

1.自定义类型切片转字节切片

```
type MyType struct {
    A int32
    B float64
}

func MyTypeSliceToByteSlice(data []MyType) []byte {
    buf := new(bytes.Buffer)
    for _,value := range data{
        if err := binary.Write(buf,binary.LettleEndian,value);err != nil {
        return nil,err
        }
    }
    return buf.Bytes(),nil
}
```

2.字节切片转自动意切片


```
func ByteSliceToMyTypeSlice(data []byte) ([]MyType,error) {
    buf := bytes.NewReader(data)
    var result []MyType
    for buf.Len() > 0 {
        var value MyType
        if err := binary.Read(buf,binary.LittleEndian,&value);err != nil {
        return nil,err
        }
        result = append(result,value)
    }
    return result,nil
}
```
为了提高效率也可以建议使用**gob**包进行编码和解码

```
import (
    "bytes"
    "encoding/gob"
)

func MyTypeSliceToByteSliceGob(data []MyType) ([]byte,error) {
    buf := new(bytes.Buffer)
    encoder := gob.NewEncoder(buf)
    if err := encoder.Encode(data);err != nil {
        return nil,err
    }
    return buf.Bytes(),nil
}

func ByteSliceToMyTypeSliceGob(data []byte) ([]MyType,error) {
    buf := bytes.NewBuffer(data)
    decoder := gob.NewDecoder(buf)
    var result []MyType
    if err := decoder.Decode(&result);err != nil {
        return nil,err
    }
    return result,nil
}
```

### 高效拼接字符串

使用**strings.Builder**对字符串进行拼接，使用**+**操作符会生成一个新的字符串并涉及内存分配以及数据复制

### trace

Trace工具是内嵌在Go运行时的代码来捕获程序运行时的各种事件的，包括Groutine调度，系统调用分析，垃圾回收分析，性能热点分析，分析并发问题

- 使用方法：`go test -trace xxx.out`会生成一个xxx.out的文件

- 手动添加：示例：

```
import (
    "os"
    "runtime/trace"
    "fmt"
)

func main() {
    f,err := os.Create("trace.out")
    if err != nil {
        fmt.Println(err)
        return
    }
    defer f.Close()
    
    if err := trace.Start(f);err != nil {
        fmt.Println(err)
        return
    }
    
    defer trace.Stop()
    
    ....
}
```

### 反射
- 基本用法：`reflect.Type`获取变量类型,`reflect.Value`获取变量值,`reflect.Kind`
- 获取类型信息：`reflect.TypeOf`可以获取变量的类型，ps:变量和变量指针对应的类型是不同的
- 动态调用方法：`reflect.Vlaue.MethodByName`可以在运行时根据方法名动态调用方法

示例：

```
package main

import (
    "fmt"
    "reflect"
)

type MyStruct struct{}

func (m *MyStruct) Hello(name string) {
    fmt.Println("Hello", name)
}

func main() {
    var myStruct MyStruct
    v := reflect.ValueOf(&myStruct)
    method := v.MethodByName("Hello")
    if method.IsValid() {
        method.Call([]reflect.Value{reflect.ValueOf("World")})
    }
}

```

### net/http包中的client如何实现长链接

 要通过`net/hettp`包中的客户端（http.Client）实现长链接需要设置`Transport`的`DisableKeepAlives`字段为`false`,默认情况下就是如此。还可以通过设置`Transport`的`MaxIdleConns`和`MaxIdleConnsPerHost`来控制连接池的连接数。
 
示例：

```
package main

import (
    "net/http"
    "time"
)

func main() {
    transport := &http.Transport{
        MaxIdleConns:        100,
        MaxIdleConnsPerHost: 10,
        IdleConnTimeout:     90 * time.Second, //闲置连接数决定在没有请求进行时，客户端可以保留多长链接，链接在`IdleConnTimeout`时间内保持可用，超时关闭
    }

    client := &http.Client{
        Transport: transport,
    }

    // 发送请求并利用长连接
    resp, err := client.Get("http://example.com")
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()

    // 处理响应...
}

```

另外：

 - Http/2:`http.Client`还支持HTTP/2协议，天生支持长链接性能更好，无需特殊设置，确保`http.Transport`默认配置即可，若想手动开启，可使用`golang.org/x/net/http2`包进一步配置

 - 连接池：go的Http客户端内部实现了一个连接池，复用链接

 示例：
 
```
import (
    "net/http"
    "golang.org/x/net/http2"
)

func main() {
    transport := &http.Transport{}
    http2.ConfigureTransport(transport)

    client := &http.Client{
        Transport: transport,
    }

    // 发送请求
    resp, err := client.Get("https://http2.golang.org")
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()

    // 处理响应...
}

```

- TimeOut设置：使用`http.Client`的`Timeout`字段可以避免请求挂起，还可以设置`Transport`的其他超时字段，如：`ResponseHeaderTimeout`和`ExpectContinueTimeout`,更全面的控制每个请求的生命周期



### runtime.Gosched()
当调用`runtime.Gosched()`时，当前的goroutine会将控制权还给Go的调度器，调度器会选择另一个goroutine执行，当前的goroutine回到队列，仅在下一次被调度到时才继续执行，适用于密集计算以及等待其他goroutine的结果

### 特定情况下的协程与线程绑定

在与某些线程局部存储（Thread-Local Storage，TLS）的库交互时，可以使用`runtime.LockOSThread`和`runtime.UnlockOSThread`来绑定协程到特定线程

### 查看协程数量

runtime.NumGoroutine

### channel底层结构


```
type hchan struct {
	qcount   uint           // 队列中所有数据总数
	dataqsiz uint           // 环形队列的 size
	buf      unsafe.Pointer // 指向 dataqsiz 长度的数组
	elemsize uint16         // 单个元素大小
	closed   uint32         // 队列是否已经被关闭
	elemtype *_type // 保存的元素类型
	sendx    uint   // 已发送的元素在环形队列中的位置
	recvx    uint   // 已接收的元素在环形队列中的位置
	recvq    waitq  // 接收者的等待队列
	sendq    waitq  // 发送者的等待队列

	lock mutex  // 数据保护锁
}

```
常见陷阱：
1. 关闭已关闭的channel：导致panic

```
func safeClose(ch chan int) {
    defer func() {
        if recover() != nil {
            fmt.Println("Channel already closed")
        }
    }()
    close(ch)
}

```

2.从已关闭的channel接收数据：不会阻塞，返回元素类型的零值

3.向已关闭的channel写数据：panic


### channel可能会引起的资源泄漏

1.未关闭的chhannel

2.无限制的缓冲channel

3.事件循环中的死锁

### 抢占式调度

抢占式调度是一种操作系统级别的调度机制，用于确保系统内的各进程或线程能公平的使用CPU资源，避免某个进程长时间独占CPU资源。Go的抢占式调度通过在协程的运行过程中定期引入中断点（如，函数调用，循环边界等）从而让调度器有机会在合适的时机进行调度判断，决定是否需要将当前正在执行的协程切换出去。


### GMP调度模型
GMP模型将高并发任务分解为Goroutines(G),Machines(M)和Processors(P)。这种模型旨在提高并发执行效率和性能。

- P的具体职责：
    - 上下文管理：p持有goroutine队列和本地运行时信息
    - 负载均衡：p可以在不同的M之间移动goroutine，从而避免某个M过载或空闲
    - 资源管理：当系统中有空闲的p时，可以将其借给繁忙的M，最大化系统资源的利用

### Go Schedule
调度器，负责管理和调度goroutine的执行，使用了是一中M:N模型的调度机制，即N个goroutine映射到M个系统线程中

工作原理：

  - 1.新的goroutine被创键后会被分配到某个p的运行队列中
  - 2.p会从其运行队列中取出goroutine，并交给空闲的M执行
  - 3.如果一个P中的goroutine数量过多，会将部分goroutine移动到其他空闲的p

 通过运行时包的初始化启动进程。在程序启动时通过`runtime scheduler`来启动调度循环 

### sync.Map优缺点
- 优点：
    - 1.并发安全
    - 2.简化代码
- 缺点：
    - 1.性能：对于频繁的写入，性能较低    
    - 2.拓展性不好

性能优化：

 - 1.采用分离锁和原子操作来避免全局锁竞争
 - 读写分离：sync.Map将读多和写少的操作分离开   

### 读写锁底层实现
`sync.RWMutex`底层是通过包含一个互斥锁和若干个计数器来实现的，

- 写锁：通过一个互斥锁实现
- 读锁：被多个goroutine同时持有，为了防止读操作频繁申请锁而导致性能下降，读取操作采用计数操作；
     - 读上锁:判断当前是否可以获取读锁，并使用若干计数器管理其状态。每获取读锁的操作会增加一个读计数，为正时，表示有活跃的读锁
     - 读解锁：每个释放读锁的操作会减少一个读计数，当读计数降至零食读锁被完全释放 
 

### Mutex几种状态
1. unLocked
2. Locked

### Mutex的正常模式和饥饿模式
- 正常模式：Mutex允许多个goroutine等待锁，但不会偏向与其中某一个goroutine，所有等待的goroutine按照进入的顺序获取
- 饥饿模式：某个goroutine等待锁的时间过长，Mutex进入饥饿模式，Mutex给等待时间最长的Mutex优先权，直到队列中的goroutine全部获取到锁退出饥饿模式

### Mutex允许自旋的条件
当尝试获取锁的goroutine发现锁已经被其他goroutine占用时，如果锁的持有时间较短(锁预计很快会被释放)，他将进行自旋等待。且系统资源充足。

### Cond
用于多个goroutine之间实现同步。包含三个主要方法：Wait,Signal和Broadcast。Wait会将调用的goroutine阻塞，直到收到Signal和Broadcast信号；
示例：

```
package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {
	var mu sync.Mutex
	cond := sync.NewCond(&mu)

	for i := 0; i < 10; i++ {
		go func(i int) {
			cond.L.Lock()
			defer cond.L.Unlock()
			cond.Wait()
			fmt.Printf("Goroutine %d is awake\n", i)
		}(i)
	}

	time.Sleep(time.Second)
	for i := 0; i < 10; i++ {
		cond.Signal() // 被唤醒的 goroutine 会依次打印消息
		time.Sleep(100 * time.Millisecond)
	}
}

```

### 原子操作
指不可分割的操作，在执行过程中不被任何其他操作或线程打断。
由`sync/atomic`包提供


### 原子操作与锁的区别
- 原子操作是利用硬件支持的原子指令实现的，不需要上下文切换；开销小
- 锁需要操作系统提供支持，一般涉及上下恩切换

### sync.Pool作用
主要用于临时对象的缓存，减少GC压力和避免重复创建对象

- 工作原理：底层使用了一个锁个一个线程本地存储来管理池中对象

### goroutine什么时候会被挂起
1.调用`time.Sleep()`
2.当前goroutine等待channel操作
3.系统调用（syscall）
4.遇到同步原语（mutex,waitgroup）
5.runtime.Gosched

### g0栈和用户栈
g0栈和用户栈之间的切换通常发生在执行系统调用时或者运行垃圾收集以及调度器活动需要内核参与的操作时。

 - g0栈：每个操作系统线程M都有一个g0栈，这是用于执行调度和运行时系统代码的栈,由Go运行时分配管理
 - 用户栈：每个goroutine都有自己的栈，默认大小2kb会动态调整，用于运行应用代码



### sysmon后台监控线程做了什么

- 垃圾回收的触发
- 处理抢占
- M的唤醒
- 系统监测

### Go中的接口是如何在底层实现的？运行时如何判断一个类型是否实现了某个接口？

 1. **接口的底层实现**  
Go的接口在底层通过两个结构体表示，分别对应空接口（`interface{}`）和带方法的接口：

- **空接口（`eface`）**：  
  ```go
  type eface struct {
      _type *_type         // 指向类型元数据
      data  unsafe.Pointer // 指向实际数据的指针
  }
  ```

- **带方法的接口（`iface`）**：  
  ```go
  type iface struct {
      tab  *itab          // 接口类型与方法表
      data unsafe.Pointer // 指向实际数据的指针
  }
  ```

- **`itab`结构**：  
  ```go
  type itab struct {
      inter *interfacetype // 接口类型信息
      _type *_type         // 具体值的类型信息
      hash  uint32         // 类型哈希值（用于类型断言）
      _     [4]byte
      fun   [1]uintptr     // 方法表（指向具体类型的方法地址）
  }
  ```

---

 2. **接口实现的核心机制**  
- **方法表生成**：  
  - 编译器为每个**具体类型**生成方法表（按接口方法顺序排序）。  
  - 当将具体类型赋值给接口时，运行时动态创建`itab`，填充方法地址。  

- **类型断言检查**：  
  - 运行时通过比较`itab.inter`和`itab._type`的哈希值，判断类型是否满足接口。  
  - 若缓存中存在匹配的`itab`，直接复用；否则遍历类型方法表匹配接口方法。  

---
 3. **接口方法匹配规则**  
- **隐式实现**：无需显式声明（与Java不同），只需方法签名完全匹配。  
- **方法集匹配**：  
  - **值类型**：实现接口所有方法（无论接收者为值或指针）。  
  - **指针类型**：仅实现接口方法中接收者为指针的方法。  

**示例**：  
```go
type Speaker interface { Speak() }

type Dog struct{}
func (d Dog) Speak() {}   // 值接收者
func (d *Dog) Run() {}    // 指针接收者

var s Speaker
s = Dog{}       // 合法：Dog值类型实现Speaker
s = &Dog{}      // 也合法

var s2 Speaker
s2 = (*Dog)(nil) // 合法：*Dog类型也实现Speaker
```

---
 4. **运行时类型断言（Type Assertion）的底层逻辑**  
```go
value, ok := v.(Speaker)
```
- 步骤1：检查接口的`itab._type`是否与目标类型一致。  
- 步骤2：若匹配，返回`data`指针和`true`；否则返回零值和`false`。  

---

 5. **性能特点**  
- **动态派发开销**：接口方法调用比直接调用多一次指针跳转（通过`itab.fun`）。  
- **缓存优化**：频繁使用的`itab`会被缓存，减少重复计算。  

---

 6. **调试工具验证**  
可通过`unsafe`包和反射查看接口底层信息：  
```go
func inspectInterface(v interface{}) {
    iface := (*iface)(unsafe.Pointer(&v))
    fmt.Printf("Type: %v, Methods: %v\n", iface.tab._type, iface.tab.fun)
}
```

---

**总结**：Go接口通过`itab`实现动态派发，方法匹配在编译时生成，运行时通过类型哈希和方法表快速判断。这种设计平衡了灵活性与性能，是Go多态的核心机制。