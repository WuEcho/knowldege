# 观察者模式(Observer)

定义对象间的一种一对多依赖关系，使得每当一个对象状态发生改变时，其相关依赖对象皆得到通知并被自动更新。观察者模式又叫发布-订阅(Publish/Subscribe)模式，模式-视图(Modl/View)模式，源-监听器(Source/Listener)模式或从属者(Dependents)模式。

###优缺点
####优点

- 观察者模式可以实现表示层和数据逻辑层的分离，并定义了稳定的消息更新传递机制，抽象了更新接口，使得可以有各种各样不同的表示层作为具体观察者角色。
- 观察者模式在观察目标和观察者之间建立一个抽象的耦合
- 观察者模式支持广播通信

####缺点

- 如果一个观察目标对象有很多直接和间接的观察者的话，将所有的观察者都通知到会花费很多时间
- 如果在观察者和观察者目标之间有循环依赖的话，观察目标会触发它们之间进行循环调用，可能导致系统崩溃
- 观察者模式没有相应的机制让观察者知道所观察者的目标对象时怎么发生变化的，而仅仅只是知道观察目标发生了变化


```go
package main

import "fmt"

type Observer interface {
	Notify(interface{})
}

type Subject struct {
	observers []Observer
	state      string
}

func (s *Subject)SetState(state string) {
	s.state = state
	s.NotifyAllObservers()
}

func (s *Subject)Attach(observer ... Observer)  {
	s.observers = append(s.observers,observer...)
}

func (s *Subject)NotifyAllObservers()  {
	for _,obs := range s.observers{
		obs.Notify(s)
	}
}

type AObject struct {
	Id string
}

func (ao *AObject) Notify(sub interface{})  {
	fmt.Println(ao.Id,"receive",sub.(*Subject).state)
}

func main() {
   sub := &Subject{}
	a := &AObject{Id: "A"}
	b := &AObject{Id: "B"}
	sub.Attach(a,b)
	sub.SetState("hello world")
	sub.SetState("i know")
}
```

