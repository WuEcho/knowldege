# 装饰模式(Decorator)
动态的给一个对象增加一些额外的职责,就增加对象功能来说，装饰模式比生成子类实现更为灵活。


装饰模式的主要优点在于可以提供比继承更多的灵活性，可以通过一种动态的方式来扩展一个对象的功能，并通过使用不同的具体装饰类以及这些装饰类的排列组合，并且具体构件类与具体装饰类可以独立变化，用户可以根据需要增加新的具体构件类和具体装饰类；其缺点在于使用装饰模式进行系统设计时将产生很多小对象，对于多次装饰的对象排错调试也更为麻烦。


```go

import "strings"

type MessageBuilder interface {
	Build(message ... string) string
}

type BaseMessageBuilder struct {
}

func (b *BaseMessageBuilder) Build(messaage ... string) string {
	return strings.Join(messaage,",")
}

//引号装饰器
type QuoteMessageBuilderDecorator struct {
	Builder MessageBuilder
}

func (q *QuoteMessageBuilderDecorator) Build(message ... string) string {
	return "\""+q.Builder.Build(message...)+"\""
}

type BraceMessageBuilderDecorator struct {
	Builder MessageBuilder
}

func (b *BraceMessageBuilderDecorator) Build(message ... string) string {
	return "{"+b.Builder.Build(message...)+"}"
}

func main() {
	var mb MessageBuilder

	mb = &BaseMessageBuilder{}

	println(mb.Build("hello world"))

	mb = &QuoteMessageBuilderDecorator{Builder: mb}

	println(mb.Build("hello world"))

	mb = &BraceMessageBuilderDecorator{mb}
      println(mb.Build("hello world"))
}

```

