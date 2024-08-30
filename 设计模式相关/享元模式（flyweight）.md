# 享元模式（flyweight）
运用共享技术有效的支持大量细粒度对象的复用。系统只使用少量的对象，而这些对象都很相似，状态变化很小，可以实现对象的多次复用。由于享元模式能够共享的对象必须是细粒度对象，因此它又称为轻量级模式，它是一种对象结构型模式。

##优缺点
### 优点
可以极大地减少内存中对象的数量，使得相同对象或相似对象在内存中只保存一份
### 缺点
享元模式使得系统更加复杂，需要分离出内部状态和外部状态，这使得程序的逻辑复杂化

##模式
享元模式包含四个角色：抽象享元类声明一个接口，通过它可以接受并作用于外部状态；具体享元类实现了抽象享元接口，其实例称为享元对象；非共享具体享元是不能被共享的抽象享元类的子类；享元工厂类用于创建并管理享元对象，它针对抽象享元类编程，将各类类型的具体享元对象存储在一个享元池中。


```go
import "fmt"

type DbConnect struct {
}

func (*DbConnect)Do()  {
	fmt.Println("connect.....doing....")
}

type DbConnectPool struct {
	ConnChan chan *DbConnect
}

func NewDbConnectPool(chanlen int) *DbConnectPool {
	return &DbConnectPool{
		make(chan *DbConnect,chanlen),
	}
}

func (dc *DbConnectPool) Get() *DbConnect {
	select {
	case conn := <- dc.ConnChan:
		return conn
	default:
		return new(DbConnect)
	}
}

func (dc *DbConnectPool) Put(conn *DbConnect)  {
	select {
	case dc.ConnChan <- conn:
		return
	default:
		return
	}
}

func main() {
      pool := NewDbConnectPool(2)
	conn := pool.Get()
	conn.Do()
	//pool.Put(conn)
}


```

