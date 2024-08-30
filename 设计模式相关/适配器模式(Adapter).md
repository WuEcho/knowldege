# 适配器模式(Adapter)

将一个接口转换成客户希望的另一个接口，适配器模式试接口不兼容的那些类可以一起工作。适配器模式既可以作为类结构型模式，也可以作为对象结构型模式。

 

```go
package main

type NoRechargeAbleBattery interface {
	Use()
}

type RechargeAbleBattery interface {
	Use()
	Charge()
}

type NoRechargeAbleBatteryA struct {
}

func (NoRechargeAbleBatteryA) Use(){
	println("NoRechargeAbleBatteryA using")
}


//对象适配器
type AdapterNoToYes struct {
	NoRechargeAbleBattery
}

func (AdapterNoToYes) Charge()  {
	println("AdapterNoToYes changed")
}

//接口的适配器
type RechargeableBatteryAbstract struct {
}

func (RechargeableBatteryAbstract) Use()  {
	println("RechargeableBatteryAbstract using")
}

func (RechargeableBatteryAbstract) Charge()  {
	println("RechargeableBatteryAbstract charging")
}

type NoRechargeableB struct {
	RechargeableBatteryAbstract
}

func (NoRechargeableB) Use() {
	println("NoRechargeableB using")
}


func main() {
	var battery RechargeAbleBattery
      battery = AdapterNoToYes{NoRechargeAbleBatteryA{}}
      battery.Use()
      battery.Charge()

      battery = NoRechargeableB{}
      battery.Use()
      battery.Charge()
}


```


