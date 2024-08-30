# go语言查缺补漏


###通过反射访问私有变量

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

###闭包


```
func adder() func(x int) int {
       var sum = 0
        return func(x int) int {
            sum += x
            return sum
        }
}

```


###defer快照失效的情况

defer的变量快照是指defer语句在定义时所捕获的变量状态，在如下状态下会失效：1.匿名函数闭包， 2.引用类型


###init
init()函数在程序启动时运行，程序启动时程序的执行顺序为：包导入，变量初始化，inint()函数启动，main函数启动

###rune类型

rune类型用来表示Unicode码点的。它本质上是int32类型的别名，用来方便处理和表示字符

###打印字符串%v和%+v的区别

区别在于打印结构体的效果不同

- 1.**%v**适用于打印变量的值，打印结构体时，只会显示字段的值而不显示名字

- 2.**%+v**适用于详细打印结构体的内容包括名字和值

ps :**%d**,**%f**,**%s**这些用于打印整数，字符串和浮点数，**%q**打印带引号的字符串或带引号的字符

###枚举
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

###自定义类型切片与字节切片互转

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

###高效拼接字符串

使用**strings.Builder**对字符串进行拼接，使用**+**操作符会生成一个新的字符串并涉及内存分配以及数据复制

###trace

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

