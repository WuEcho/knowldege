# 备忘录模式(memento)

在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态，以便以后当需要时将该对象恢复到原先保存的状态。又称快照模式

###优缺点
####优点

- 提供一种可以恢复状态的机制，当用户需要时能够比较方便的将数据恢复到某个历史状态。
- 实现了内部状态的封装。除了创建它的发起人外，其他对象都不能够访问这些状态信息

####缺点

- 资源消耗大。如果要保存的内存状态信息过多或频繁，占用较大的内存资源。


```go
package main

import "fmt"

type Memento interface {}

type Game struct {
	hp,mp int
}

type gameMemento struct {
	hp,mp int
}

func (g *Game) Play(mpDelta,hpDelta int) {
	g.hp += hpDelta
	g.mp += mpDelta
}

func (g *Game) Save() Memento {
	return &gameMemento{
		hp: g.hp,
		mp: g.mp,
	}
}

func (g *Game) Load(m Memento) {
	gm := m.(*gameMemento)
	g.mp = gm.mp
	g.hp = gm.hp
}

func (g *Game) Status()  {
	fmt.Printf("current hp:%d,mp:%d \n",g.hp,g.mp)
}

func main() {
	g := &Game{
		hp: 10,
		mp: 12,
	}

	g.Status()
	p := g.Save()


	g.Play(-1,-4)
	g.Status()

      g.Load(p)
	g.Status()
}

```

###输出

```
current hp:10,mp:12 
current hp:6,mp:11 
current hp:10,mp:12 
```



















