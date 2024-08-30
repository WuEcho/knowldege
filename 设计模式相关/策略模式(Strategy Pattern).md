# 策略模式(Strategy Pattern)

定义一系列算法，将每个算法封装起来，并让它们可以互相替换。策略模式让算法独立于使用它的客户而变化。

###优缺点
####优点

- 用户可以在不修改原有系统的基础上选择算法或行为，也可以灵活的增加新的算法或行为
- 策略模式提供了管理相关的算法簇的办法
- 策略模式提供了可以替换继承关系的办法
- 使用策略模式可以避免使用多重条件转移语句

####缺点
 
 - 策略模式将造成产生很多策略类，可以通过使用享元模式在一定程度上减少对象的数量
 - 客户端必须知道所有的策略类，并自行决定使用哪一个策略类

 
 
```go
package main

import "fmt"

type Strategy interface {
	Do(interface{})
}

type AToB struct {
	//距离
	Distance float64
	//到达方式策略
	Strategy Strategy
}

func (ab *AToB) Do() {
	if ab.Strategy != nil {
		ab.Strategy.Do(ab)
	}
}

type Bike struct {
     Speed float64
}

func (bk *Bike)Do(ab interface{})  {
	a2b,ok := ab.(*AToB)
	if ok && bk.Speed <= 0.0001{
		return
	}
	fmt.Println("自行车 用时：",a2b.Distance/bk.Speed)
}

type Bus struct {
	Speed float64
}

func (bs *Bus)Do(ab interface{})  {
	a2b,ok := ab.(*AToB)
	if ok && bs.Speed <= 0.0001{
		return
	}
	fmt.Println("巴士 用时：",a2b.Distance/bs.Speed)
}

type Air struct {
	Speed float64
}

func (air *Air)Do(ab interface{})  {
	a2b,ok := ab.(*AToB)
	if ok && a2b.Distance <= 0.0001{
		return
	}
	fmt.Println("飞机 用时：",a2b.Distance/air.Speed)
}

func main() {
	a2b := AToB{Distance: 600}

	a2b.Strategy = &Bike{Speed: 10}
	a2b.Do()

      a2b.Strategy = &Bus{Speed: 50}
      a2b.Do()

      a2b.Strategy = &Air{Speed: 500}
      a2b.Do()
}

```
 
###输出


```
自行车 用时： 60
巴士 用时： 12
飞机 用时： 1.2
``` 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

