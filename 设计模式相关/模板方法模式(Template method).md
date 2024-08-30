# 模板方法模式(Template method)

定义一个操作中的算法骨架，而将算法的一些步骤延迟到子类中，使得子类可以不改变该算法结构的情况下重新定义该算法的某些特定步骤。

###优缺点
####优点

- 它封装了不变部分，扩展可变部分。他把认为是不变部分的算法封装到父类中实现，而把可变部分算法由子类继承实现，便于子类继续扩展
- 它在父类中提取了公共的部分代码，便于代码复用
- 部分方法是由子类实现的，因此子类可以通过扩展方式增加相应的功能

###缺点

- 对每个不同的实现都需要定义一个子类，这会导致类的个数增加
- 父类中抽象方法由子类实现，子类执行的结果会影响父类的结果，这导致一种反向的控制结构
- 由于继承关系自身的缺点，如果父类添加新的抽象方法，所有子类都要改一遍


由于Golang不提供继承机制，需要使用匿名组合模拟实现继承。此处需要注意：因为父类需要调用子类方法，所以子类需要匿名组合父类的同时，父类需要持有子类的引用。



```go
package main

import "fmt"

type Downloader interface {
	Download(uri string)
}

type template struct {
	implement
	uri string
}

type implement interface {
	download()
	save()
}

func newTemplate(impl implement) *template {
	return &template{
		implement:impl,
	}
}

func (t *template) Download(uri string) {
	t.uri = uri
	fmt.Printf("prepare downloading\n")
	t.implement.download()
	t.implement.save()
	fmt.Println("finish downloading \n")
}

func (t *template) save() {
	fmt.Println("default save \n")
}

type HttpDolandler struct {
	*template
}

func NewHttpDowlandler() Downloader {
	d := &HttpDolandler{}
	temp := newTemplate(d)
	d.template = temp
	return d
}

func (d *HttpDolandler)download()  {
	fmt.Printf("download %s via http\n",d.uri)
}

func (d *HttpDolandler)save()  {
	fmt.Printf("http save\n")
}


type FTPDownloader struct {
	*template
}

func newFTPDownloader() Downloader {
	d := &FTPDownloader{}
	tem := newTemplate(d)
	d.template = tem
	return d
}

func (f *FTPDownloader)download() {
	fmt.Printf("download %s via ftp\n",f.uri)
}

func main() {
	d := NewHttpDowlandler()
	d.Download("http://example.com/abc.zip")

	println("-----------")

	d1 := newFTPDownloader()
	d1.Download("ftp://example.com/abc.zip")

}
```

###输出


```
prepare downloading
download http://example.com/abc.zip via http
http save
finish downloading 

-----------

prepare downloading
download ftp://example.com/abc.zip via ftp
default save 

```


