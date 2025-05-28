## docker

要使其在启动时自动启动 Docker 和 containerd，请运行以下命令：
```
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```


要停止此行为，请disable改用。
```
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```