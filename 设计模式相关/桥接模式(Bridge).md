# 桥接模式(Bridge)
将抽象部分与它的实现部分分离，使他们都可以独立的变化。它是一种对象结构型模式，又称为柄体模式或接口模式

重点需要理解如何将抽象化与实现化脱耦，使得两者可以独立变化。

- 抽象化：抽象化就是忽略一些信息，把不同的实体当做同样的实体对待。在面向对象中，将对象的共同性质抽取出来形成类的过程
- 实现化：针对抽象化给出的具体实现，就是实现化，抽象化与实现化是一对互逆的概念，实现化产生的对象比抽象化更具体
- 脱耦：就是将抽象化与实现化之间的继承关系改为关联关系。


```go
package pattern

import (
   "fmt"
   "net/http"
)

type Request interface{
    HttpRequest() (*http.Request,error)
}

type Client struct {
    Client *http.Client
}

func (c *Client) Query(req Request) (resp *http.Response,err error){
   req,_ := req.HttpRequest()
   resp,err = c.Client.Do(req)
   return
}


type CdnRequest struct {}

fun (cdn *CdnRequest) HttpRequest() (*http.Request,error){
    return http.NewRequest("GET","/cdn",nil)
}

type LiveRequest struct {}

func (live *LiveRequest) HttpRequest() (*http.Request,error){
    return http.NewRequest("GET","/live",nil)
}

func TestBridge() {
   client := &Client{http.DefaultClient}
   
   cdnReq := &CdnRequest{}
   client.Query(cdnReq) 
   
   liveReq := &LiveRequest{}
   client.Query(liveReq)
}
```

###优缺点
####优点

- 桥接模式提高了系统的可扩充性，在两个变化维度中任意扩展一个维度，都不需要修改原有系统

####缺点

- 引入桥接会增加系统理解与设计的难度
















































