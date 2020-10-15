# Docker启动etcd集群

## 用途

本地Docker一键同时启动多个etcd，并配置集群信息

## 版本

* etcd version: 3.4.13
* docker version: 19.03.13

## 使用

**请确保安装了[docker](https://docs.docker.com/get-docker/)**

1. 设置docker网络

   ```shell
   docker network create -d bridge --subnet 192.168.28.0/32 mynetwork
   ```

   

2. Linux下启动集群

   ```shell
   curl -O https://raw.githubusercontent.com/hcolde/etcd/main/run.sh && chmod +x ./run.sh && ./run.sh 3
   ```

   ```3表示启动3个集群，本示例最多可启动253个etcd，如需更多请自行设置docker网络及启动配置```