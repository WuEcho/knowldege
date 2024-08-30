# linux上构造docker容器

###1. 安装Docker

https://yeasy.gitbook.io/docker_practice/install/ubuntu

安装docker compose 

https://blog.csdn.net/qq_40600379/article/details/132221256

# 对于Ubuntu系统
sudo apt update
sudo apt install docker.io

# 对于CentOS系统
sudo yum install docker

###2. 启动docker

sudo systemctl start docker


####3. 配置免密
cd ~/.ssh

ls 
查看自己的id_res.pub
/home/ubuntu/.ssh
将自己的key复制到文件里。

#### 4 卸载旧版本

```
sudo apt-get remove docker docker-engine docker.io containerd runc
```


#### 4.1 获取软件最新源

```
sudo apt-get update
```
#### 4.2 安装apt依赖包

```
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
``` 
#### 4.3 安装GPG证书

```
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
```

####4.4 设置稳定版仓库

```
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
```

#### 4.5 安装 Docker Engine-Community

####4.5.1 更新apt包索引

```
sudo apt-get update
```

####4.5.2 安装最新版本

```
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

### 5 停止docker

```
sudo service docker stop
```

### 6. 重启docker

```
sudo service docker restart
```

###7 配置 Docker 用户组

```
sudo usermod -aG docker $USER
```

l1:https://sepolia-faucet.pk910.de/

/config/environments/testnet

config/environments/testnet}/node.config.toml

