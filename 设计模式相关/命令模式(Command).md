# 命令模式(Command)
将一个请求封装为一个对象，从而使可用不同的请求对客户进行参数化；对请求派对或者记录日志，以及支持可撤销的操作。

命令模式是一种数据驱动的设计模式，请求以命令的形式包装在对象中，并传给调用对象。调用对象寻找可以处理该命令的合适对象，并把该命令传给相应的对象，该对象执行命令。


##模式应用
很多系统都提供了宏命令功能，如Unix平台下的shell编程，可以将多条命令封装在一个命令对象中，只需要一条简单的命令即可执行一个命令序列

##模式扩展
宏命令又称为组合命令，它是命令模式和组合模式联用的产物。

- 宏命令也是一个具体命令，不过它包含了对其他命令对象的引用，在调用宏命令的execute()方法时，将递归调用它包含的每个成员命令的execute()方法，一个宏命令成员对象可以是简单命令，还可以继续是宏命令。


```go
package main

import (
	"errors"
	"fmt"
)

//命令接口
type Command interface {
	Do(args interface{})(interface{},error)
}

type GetCommand struct {
}

func (gc *GetCommand) Do(args interface{}) (interface{},error) {
	fmt.Println("get Command")
	return args,nil
}

type PutCommand struct {
}

func (pc *PutCommand) Do(args interface{}) (interface{},error){
	fmt.Println("put command")
	return args,nil
}


type CmdContext struct {
	CmdType string
	Args    interface{}
}

type CommandHandler struct {
	CmdMap map[string]Command
}

func (ch *CommandHandler) Handle(ctx *CmdContext) (interface{},error){
	if ctx == nil {
		return nil,errors.New("illegal")
	}

	cmd,ok := ch.CmdMap[ctx.CmdType]
	if ok {
		return cmd.Do(ctx.Args)
	}
	return nil,errors.New("invalid command")
}

func (ch *CommandHandler) Register(cmdType string,cmd Command)  {
	ch.CmdMap[cmdType] = cmd
}

func main() {
      cmdHandler := &CommandHandler{CmdMap: make(map[string]Command)}
      gtCtx := &CmdContext{CmdType: "get",Args: "Get"}
      ptCtx := &CmdContext{CmdType: "put",Args: "Put"}

      cmdHandler.Register("put",&PutCommand{})
      cmdHandler.Register("get",&GetCommand{})

      println(cmdHandler.Handle(gtCtx))
	println(cmdHandler.Handle(ptCtx))
}

```


