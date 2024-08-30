# 访问者模式(Visitor)

访问者模式可以给一系列对象透明的添加功能，并且把相关代码封装到一个类中。对象主要预留访问者接口Accept则后期为对象添加功能的时候就不需要改动对象。


```go
package main

import "fmt"

type Customer interface {
	Accept(Visitor)
}

type Visitor interface {
	Visit(customer Customer)
}

type CustomerCol struct {
	customers []Customer
}

func (c *CustomerCol) Add(customer Customer) {
	c.customers = append(c.customers,customer)
}

func (c *CustomerCol) Accept(visitor Visitor)  {
	for _,customer := range c.customers{
		customer.Accept(visitor)
	}
}

type EnterpriseCustomer struct {
	name string
}

func NewEnterpriseCustomer(name string) *EnterpriseCustomer {
	return &EnterpriseCustomer{
		name: name,
	}
}

func (c *EnterpriseCustomer) Accept(visitor Visitor) {
	visitor.Visit(c)
}

type IndividualCustomer struct {
	name string
}

func NewIndividualCustomer(name string) *IndividualCustomer {
	return &IndividualCustomer{
		name: name,
	}
}

func (c *IndividualCustomer) Accept(visitor Visitor)  {
	visitor.Visit(c)
}

type ServiceRequestVisitor struct {}

func (s *ServiceRequestVisitor) Visit(customer Customer)  {
	switch  c := customer.(type)  {
	case *EnterpriseCustomer:
	      fmt.Printf("serving enterprise customer %s \n",c.name)
	case *IndividualCustomer:
		fmt.Printf("serving individual customer %s \n",c.name)
	}
}

//only for enterprise
type AnalysisVisitor struct {}

func (a *AnalysisVisitor) Visit(customer Customer)  {
	switch c := customer.(type) {
	case *EnterpriseCustomer:
		fmt.Printf("analysis enterprise customer %s \n",c.name)
	}
}

func main() {
     c := &CustomerCol{}
     c.Add(NewEnterpriseCustomer("A company"))
     c.Add(NewEnterpriseCustomer("B company"))
     c.Add(NewIndividualCustomer("bob"))
     c.Accept(&ServiceRequestVisitor{})

     println("-----------------------")

     c1 := &CustomerCol{}
     c1.Add(NewEnterpriseCustomer("A compamy"))
     c1.Add(NewEnterpriseCustomer("B company"))
     c1.Add(NewIndividualCustomer("bob"))
     c1.Accept(&AnalysisVisitor{})
}

```

###输出


```
serving enterprise customer A company 
serving enterprise customer B company 
serving individual customer bob 
-----------------------
analysis enterprise customer A compamy 
analysis enterprise customer B company 
```


