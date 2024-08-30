# 迭代器模式（Iterator）

提供一种方法顺序访问一个聚合对象中的各种元素，而又不暴露该对象的内部表示。


```go
package main

import "fmt"

type Aggregate interface {
	Iterator() Iterator
}

type Iterator interface {
	First()
	IsDone() bool
	Next() interface{}
}

type Number struct {
	start,end int
}

func NewNumbers(start,end int) *Number {
	return &Number{
		start: start,
		end: end,
	}
}

func (n *Number) Iterator() Iterator {
	return &NumberIterator{
		numbers: n,
		next: n.start,
	}
}

type NumberIterator struct {
	numbers *Number
	next    int
}

func (i *NumberIterator) First()  {
	i.next = i.numbers.start
}

func (i *NumberIterator) IsDone() bool {
	return i.next > i.numbers.end
}

func (i *NumberIterator) Next() interface{} {
	if !i.IsDone() {
		next := i.next
		i.next++
		return next
	}
	return nil
}

func IteratorPrint(i Iterator)  {
	for i.First();!i.IsDone(); {
		c := i.Next()
		fmt.Printf("%#v\n",c)
	}
}

func main() {
    var aggre Aggregate
    aggre = NewNumbers(1,10)
    IteratorPrint(aggre.Iterator())
}
```


###输出
```
1
2
3
4
5
6
7
8
9
10
```

