

# docker_network手册

## 一、docker

 ### 1.常见指令

> 在 Docker 环境中，网络是实现容器之间以及容器与外部世界通信的关键部分。不同的网络设置可以满足不同的应用场景需求。

这个参数用于指定容器运行时所连接的网络。通过指定特定的网络，可以控制容器的网络隔离程度、访问权限以及与其他容器或外部服务的通信方式

1.Docker 网络创建的基本命令格式如下：

```shell
docker network create [OPTIONS] NETWORK
docker network create --driver bridge my-custom-network
# 查看网络列表
docker network ls # 查看自定义的my-custom-network
docker network rm my-custom-network # 
docker network inspect b36ae4ff2f5e #
```

创建网络：它告诉 Docker 创建一个新的网络。
指定驱动：通过 --driver bridge 指定了网络使用的驱动为 bridge。
命名网络：my-custom-network 是你给这个新网络指定的名称，之后你可以通过这个名字来引用这个网络。

2.运行容器

在启动MySQL容器时，使用`--network`选项将其连接到上一步创建的网络

```
docker run --name mysql02 -e MYSQL_ROOT_PASSWORD=yourpassword -d --network=my-custom-network mysql:tag
```

同样地，在启动Nacos容器时，也使用`--network`选项将其连接到`my-custom-network`网络。

```
docker run --name nacos -d --network=my-custom-network -e MODE=standalone -p 8848:8848 nacos/nacos-server
```

在Nacos的`application.properties`文件中 ，但是是**使用容器内部的端口 而不是映射宿主机的端口**

```properties
spring.datasource.platform=mysql  
db.num=1  
db.url.0=jdbc:mysql://mysql02:3306/nacos_config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true  
db.user.0=root  
db.password.0=yourpassword
```

```
docker network inspect b36ae4ff2f5e 
```

将名为 `mysql02` 的容器连接到名为 `my-custom-network` 的网络的命令：

```
docker network connect my-custom-network mysql02 
docker network connect my-custom-network emqx
```

运行 `docker run` 命令时没有指定 `--network=my-custom-network`，那么容器默认会连接到 Docker 的默认网络（通常是 `bridge` 网络，但名称可能是 `bridge`、`docker0` 或其他，取决于 Docker 的版本和配置）

断开与默认网络的连接的命令如下（但请谨慎使用）：

```
docker network disconnect bridge mysql02 # 不使用，也可以增加容器网络连接
```



## 二、docker-comepose

 ### 1.comepose 自定义网络名

>  在networks自定义网路中指定name属性，这样就不会使用默认的名称生成策略

在 Compose 文件的顶层 version 下面添加如下代码：

```
networks:  
  my_network: 
    driver: bridge
    name: my_network
  halo_network:  
    driver: bridge
    name: halo_network
```



### 2.指定已经存在的网络



```
version: "3"  
  
services:  
  halo:  
    image: halohub/halo:2.18  
    container_name: halo  
    restart: on-failure:3  
    networks:  
      - my_network  
      - halo_network
    volumes:  
      - ./halo2/:/root/.halo2  
    ports:  
      - "8090:8090"  
    command:  
      - --spring.r2dbc.url=r2dbc:pool:mysql://halodb:3306/halo  
      - --spring.r2dbc.username=root  
      - --spring.r2dbc.password=2580qwe@HW
      - --spring.sql.init.platform=mysql  
      - --halo.external-url=https://lerlee.online  
      - --halo.security.initializer.superadminusername=admin  
      - --halo.security.initializer.superadminpassword=lerlee  
  
networks:  
  my_network:  
    external: true  # 假设my_network网络已经在其他docker-compose文件中定义或预先创建
  halo_network:
    external: true  # 假设halo_network网络已经在其他docker-compose文件中定义或预先创建
```







## 三、总结

在 comepose  , 外部没有 这个 my-network 而内部 使用 
