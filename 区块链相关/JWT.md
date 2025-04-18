# JWT


## 概念

　　json web token(jwt)是为了网络应用环境间传递声明而执行的一种基于JSON的开发标准(RFC 7519),该token被设计为紧凑且安全的，特别适用于分布式站点的单点登陆(SSO)场景。JWT的声明一般被用来在身份提供者和服务提供者间传递被认证的用户身份信息，以便于从资源服务器获取资源，也可以增加一些额外的其他业务逻辑所必须的声明信息，该token也可直接被用于认证，也可被加密。

　　JWT由三部分组成，将这三段信息文本用链接构成了JWT字符串，第一部分称之为**头部(header)**,第二部分称之为**载荷(payload)**，第三部分称之为**签证(signature)**。

## header
JWT的头部承载的两部分信息：

* 声明类型，这里是jwt
* 声明加密的算法，通常直接使用HMAC SHA256

完整的头部就像下面这样的JSON

```
{
 'type':'JWT'，
 'alg':'HS256'
}
```
然后将头部进行base64加密，构成了第一部分:`eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9`

## payload
载荷是存放有效信息的地方。有效信息包含三个部分:

* 标准中注册的声明
* 公共的声明
* 私有的声明

### 标注中注册的声明

* iss: jwt签发者
* sub: jwt所面向的用户
* aub: 接收jwt的一方
* exp: jwt的过期时间，这个过期时间必须大于签发时间
* nbf: 定义在什么时间之前，该jwt都是不可用的
* iat: jwt的签发时间
* jti: jwt的唯一身份标识，主要用来作为一次性token，从而回避重放攻击

### 公共的声明
　　公共的声明可以添加任何的信息，一般添加用户的相关信息或其他业务需要的必要信息，但不建议添加敏感信息，因为该部分在客户端可解密；

### 私有的声明
　　私有的声明是提供者和消费者功能定义的声明，一般不建议存放敏感信息，因为base64是对称解密的，也就是说该部分信息可归类为明文信息。
　　
定义一个payload

```
{
  "sub":"1234567890",
  "name":"John Doe"，
  "admin": true
}
```
然后将其base64加密,得到jwt的一部分：`eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9`


## Signature
jwt的第三部分是一个签证信息，这个签证信息由三部分组成：
 
- header(base64后的)
- payload(base64后的)
- secred
　　这个部分需要base64加密后的header和base64加密后的payload使用"."连接组成的字符串，然后通过header中声明的加密方式进行加sceret组合加密,然后就构成了jwt的第三部分

```
var encodedString = base64UrlEncode(header) + '.' + base64UrlEncode(payload);
var signature = HMACSHA256(encodedString,'secret'); //TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```
将这三部分用'.'连接成一个完整的字符串，构成了最终的jwt:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```

　　ps:secret是保存在服务器端的，jwt的签发也是在服务端的，secret就是用来进行jwt的签发和jwt的验证，它就是服务端的私钥，在任何场景都不应该流露出去，一旦客户端得知这个secret，那就意味着客户端可以自我签发jwt了

## 应用
一般是在请求头里面加入Authorization,并加上Bearer标注:

```
fethch('api/user/1',{
    headers:{
     'Authorization':'Bearer' + token
    }
})
```
服务端会验证token,如果验证通过就会返回相应的资源，整个流程如图：
![1147658-20171118202151718-1630139158](media/15748217990813/1147658-20171118202151718-1630139158.png)


优点：

- 因为json的通用性，所以JWT是可以跨语言支持的
- 因为有了payload部分,所以JWT可以在自身存储一些其他业务逻辑所必要的非敏感信息
- 便于传输，jwt的构成非常简单，字节占用很小，所以它非常便于传输
- 不需要在服务端保存会话信息，易于扩展




