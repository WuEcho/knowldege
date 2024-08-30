# 状态模式(State)

允许一个对象在其内部状态改变时改变它的行为，对象看起来似乎修改了它的类。其别名为状态对象(Objects for States)。在很多情况下，一个对象的行为取决于一个或多个动态变化的属性，这样的属性叫做状态，这样的对象叫做有状态的对象，这样的对象状态是从事先定义好的一系列值中取出的。当一个这样的对象与外部事件产生互动时，其内部状态就会改变，从而使得系统的行为也随之发生变化。

###优缺点
####优点

- 封装了转换规则
- 枚举可能的状态，在枚举状态之前需要确定状态种类
- 将所有与某个状态有关的行为放在一个类中，并且可以方便的增加新的种类，只需要改变对象状态即可改变对象的行为
- 允许状态转换逻辑与状态对象合成一体，而不是某一个巨大的条件语句块
- 可以让多个环境对象共享一个状态对象，从而减少系统中对象的个数

####缺点

- 状态模式的使用必然会增加系统类和对象的个数
- 状态模式的结构与实现都较为复杂，如果使用不当将导致程序结构和代码的混乱


###应用
状态模式在工作流或游戏类等典型的软件中得以广泛使用，如办公OA系统，一个批文有诸多状态：待办，正在办理，正在批示，正在审核等。



```go
package main

import "fmt"

type Light struct {
	State LightState
}

func (l *Light) PressSwitch() {
	if l.State != nil {
		l.State.PressSwitch(l)
	}
}

type LightState interface {
	PressSwitch(light *Light)
}

type OnLightState struct {

}
//开灯
func (ol *OnLightState) PressSwitch(light *Light)  {
	fmt.Println("turn on light")
	light.State = &OffLightState{}
}

type OffLightState struct {

}

func (os *OffLightState) PressSwitch(light *Light) {
	fmt.Println("turn off light")
	light.State = &OnLightState{}
}

func main() {
	light := &Light{State: &OnLightState{}}
	light.PressSwitch()
	light.PressSwitch()
}
```

###输出

```
turn on light
turn off light
```

