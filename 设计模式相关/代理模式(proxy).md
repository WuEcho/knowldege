# 代理模式(proxy)
给某个对象提供一个代理，并由代理对象控制对象的引用

##注意事项
1.与适配器模式的区别：适配器模式主要改变所考虑对象的接口，而代理模式不能改变所代理类的接口。
2.与装饰器模式的区别：装饰器模式为了增加功能，而代理模式是为了加以控制


```go
package main

import (
	"errors"
	"fmt"
)

type Device interface {
	Read() ([]byte,error)
	Write(word []byte) error
}

type HardDisk struct {
	storage []byte
}

func (h *HardDisk) Read() ([]byte,error)  {
	return h.storage,nil
}

func (h *HardDisk) Write(word []byte) error {
	h.storage = word
	return nil
}

type HardDiskProxy struct {
	OpId string
	hd   *HardDisk
}

func (h *HardDiskProxy) Read() ([]byte,error) {
	if !h.permission("read") {
		return nil,errors.New("you dont have permission to read")
	}
	return h.hd.Read()
}

func (h *HardDiskProxy)Write(word []byte) error {
	if !h.permission("write") {
		return errors.New("you dont have permission to write")
	}
	return h.hd.Write(word)
}

func (h *HardDiskProxy)permission(tag string) bool {
	if h.OpId == "admin" {
		return true
	}
	if h.OpId=="read"&&tag == "read"{
		return true
	}

	if h.OpId=="writer"&&tag=="write"  {
		return true
	}
	return false
}

func main() {
      var dev Device
      dev=&HardDiskProxy{OpId: "admin",hd: &HardDisk{}}
      dev.Write([]byte("hello"))
      data,_ := dev.Read()
      fmt.Println(string(data))

      println("-----1-----")

      dev=&HardDiskProxy{OpId: "read",hd: &HardDisk{storage: []byte("only read")}}
      err := dev.Write([]byte("hello world"))
      fmt.Println(err.Error())
      data,_ = dev.Read()
      fmt.Println(string(data))

	println("-----2-----")

      dev=&HardDiskProxy{OpId: "write",hd: &HardDisk{}}
      err = dev.Write([]byte("only write"))
      fmt.Println(err.Error())
      data,err = dev.Read()
      fmt.Println(string(data),err.Error())
}

```


```
hello
-----1-----
you dont have permission to write
only read
-----2-----
you dont have permission to write
 you dont have permission to read

```

###常见的代理类型

- 远程代理：为一个位于不听的地址空间的对象提供一个本地的代理对象。
- 虚拟代理：如果需要创建一个资源消耗较大的对象，先创建一个消耗相对较小的对象来表示，真实对象只在需要是才会被真正创建
- copy-on-write代理：虚拟代理的一种，把复制操作延迟到只有客户端真正需要时才执行。一般来说，对象的深拷贝是一个开销较大的操作，copy-on-write代理可以让这个操作延迟，只有对象被用到时才被克隆
- 保护代理：控制对一个对象的访问，可以给不同的用户提供不同的级别的使用权限
- 缓冲代理：为某一个目标操作的结果提供临时的存储空间，以便多个客户端可以共享这些结果
- 防火墙代理：保护目标不让恶意用户接近
- 同步化代理：使几个用户能够同时使用一个对象而没有冲突


