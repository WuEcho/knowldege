# Nginx 配置/api访问8080端口其他默认访问8545端口


 要在 Nginx 中配置不同的路径转发到不同的端口，你需要编辑 Nginx 的配置文件（通常是 nginx.conf 或者某个虚拟主机配置文件，例如 /etc/nginx/sites-available/default）。以下是一个示例配置，展示如何将 /api 路径的请求转发到 8080 端口，而将其他所有请求转发到 8545 端口。


```
server {
    listen 80;
    server_name your_domain.com;

    # /api 路径转发到 8080 端口
    location /api {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 其他所有请求转发到 8545 端口
    location / {
        proxy_pass http://127.0.0.1:8545;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```

### 配置解释

- 1.listen 80;：Nginx 监听 80 端口（HTTP 默认端口）。
- 2.server_name your_domain.com;：指定该配置适用于的域名，将 your_domain.com 替换为你的实际域名。
- 3.location /api {...}：当请求路径以 /api 开头时，转发到 127.0.0.1:8080。
- 4.location / {...}：其他所有请求转发到 127.0.0.1:8545。
- 5.proxy_set_header ...：这些指令设置一些代理头部，确保请求在转发过程中保留客户端的原始信息。

### 步骤
1. 打开 Nginx 配置文件：
```
sudo nano /etc/nginx/sites-available/default
```
2.添加上述配置，保存并退出编辑器。
3.测试 Nginx 配置确保没有语法错误：

```
sudo nginx -t
```
4.重新加载 Nginx 使配置生效：

```
sudo systemctl reload nginx
```
这样，Nginx 就会将 /api 路径的请求转发到 8080 端口，其他所有请求转发到 8545 端口。

注册以聊天



```
  502  sudo apt-get update
  503  sudo apt-get install nginx
  504  vim /etc/nginx/sites-available/reverse-proxy
  505  sudo vim /etc/nginx/sites-available/reverse-proxy
  506  sudo sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
  507  sudo nginx -t
  508  sudo systemctl restart nginx
```

