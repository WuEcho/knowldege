# 中介者模式(Mediator Pattern)
用一个中介对象来封装一系列的对象交互，中介者使各对象不需要显式的互相引用，从而使其耦合松散，而且可以独立的改变他们之间的交互。

中介者承担两方面的职责：

- 中转作用(结构性):通过中介者提供的中转作用，各个同事对象就不再需要显式引用其他同事，当需要和其他同事进行通信时，通过中介者即可。
- 协调作用(行为性):中介者可以进一步的对同事之间的关系进行封装，同事可以一致的和中介者进行交互，而不需要指明中介者需要具体怎么做，中介者根据封装在自身内部的协调逻辑，对同事的请求进行进一步处理，将同事成员之间的关系行为进行分离和封装。该协调作用数据中介者在行为上的支持。


###优缺点

####优点

- 简化了对象之间的交互
- 将各同事解耦
- 减少子类生成
- 可以简化各同事类的设计和实现

####缺点

- 在具体中介者类中包含了同事之间的交互细节，可能会导致具体中介者类非常复杂

###模式应用

 MVC架构中的控制器，C作为一种中介者，负责控制视图对象View和模型对象model之间的交互
 

```go
package main

type ChatRoom struct {
	name string
}

func (cr *ChatRoom) SendMsg(msg string) {
	println(cr.name+":"+msg)
}

func (cr *ChatRoom) RegisterUser(u *User) {
     u.cr = cr
}

type User struct {
	name string
	cr *ChatRoom
}

func (u *User) SendMsg(msg string)  {
	if u.cr != nil {
		u.cr.SendMsg(msg)
	}
}

func main() {
	Ausr := &User{name: "A user"}
	Busr := &User{name: "B user"}

	chatRoom := &ChatRoom{name: "chatRoom12"}
	chatRoom.RegisterUser(Ausr)
	chatRoom.RegisterUser(Busr)

	Ausr.SendMsg("hello a user")
	Busr.SendMsg("hello b User")
}

```





































