# 外观模式(facade)
外部与一个子系统的通信必须通过一个统一的外观对象进行，为了子系统中的一组接口提供一个一致的界面，外观模式定义了一个高层接口，这个接口使得这一子系统更加容易使用。

```go

import "fmt"

type Coder struct {
}

func (c *Coder) Coding() {
	fmt.Println("coding....")
}

type Tester struct {
}

func (t *Tester) Testing()  {
	fmt.Println("Testing.....")
}

type ProductPlanner struct {

}

func (p *ProductPlanner) Planing()  {
	fmt.Println("planting....")
}

type MaintenancePeople struct {

}

func (m *MaintenancePeople) Releasing() {
	fmt.Println("releasing...")
}

type Company struct {
	ProductPlanner
	Coder
	Tester
	MaintenancePeople
}

func (com *Company) Producing() {
	com.ProductPlanner.Planing()
	com.Tester.Testing()
	com.Coder.Coding()
	com.MaintenancePeople.Releasing()
}


func main() {
	 com := &Company{}
	 com.Producing()
}  
```

