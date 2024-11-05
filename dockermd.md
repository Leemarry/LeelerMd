# docker部署目录

` 提示：工作中使用docker拉取运行镜像`
例如：部署emqx、  部署mysql 、部署minio;看完整操作流程，评论一个`+1` ，谢谢啦

---

`提示：写完文章后，目录可以自动生成，如何生成可参考右边的帮助文档`

@[TOC](docker部署)

---

# 前言

`提示：工作中使用到docker做简单基础日志：`

工作中使用到docker做简单基础日志，docker更多日常使用介绍 查看doocker部署nginx-web。链接: [docker-nginx](http://t.csdnimg.cn/D60TM)

---

`提示：以下是本篇文章正文内容，下面案例可供参考`

# 一、部署emqx

>拉取的是最新版本:  ```docker pull emqx/emqx:latest```
>当然可以指定版本: ```docker pull emqx/emqx:latest:v5.0```

```powershell
docker pull emqx/emqx:latest
# 指令 需要拷贝emqx:/opt/emqx/etc  获取容器拷贝文件
docker run -d --name emqx --privileged=true -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083  emqx/emqx:latest
```

参数 `--privileged=true` 表示赋予容器特权，用于需要与主机系统交互的操作。
参数 `-p` 指定了端口映射，将容器内的端口映射到主机上，以便可以从外部访问 EMQ X 服务。
参数 `emqx/emqx:latest` 表示使用 `emqx/emqx` 仓库中最新版本的镜像运行容器


只要是为了容器内外共享数据或持久化存储容器内的数据。通过挂载文件目录，可以将主机系统上的文件或目录与容器内部的文件系统进行关联，使得容器内的操作可以直接影响主机系统上的文件，也可以使主机系统上的文件在容器内保持持久化，即使容器被删除或重建，数据仍然保留。这样做可以方便地进行数据备份、共享和管理

```powershell
mkdir -p /home/jaxf/emqx/etc /home/jaxf/emqx/lib /home/jaxf/emqx/data /home/jaxf/emqx/log  #
```

这个指令需要注意，如果你是在根目录进行输入，一定要包含全部的路径名称。
如果已经在你想要指定创建的文件夹里面，只需要指定要创建的文件夹名称即可。

操作流程： 是win操作，如果liunx 目录改宿主机root下  先创建对应文件

### 1. 拉取emqx 

拉取的是最新版本:  `docker pull emqx/emqx:latest`

```
C:\Users\Administrator>docker images
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
myapp         1.0       95592d1d433a   2 weeks ago     671MB
emqx/emqx     latest    f7eaf42f5f44   2 weeks ago     280MB 
minio/minio   latest    07520491faf1   3 weeks ago     160MB
redis         latest    509b2fc82da6   4 weeks ago     117MB
mysql         latest    7ce93a845a8a   5 weeks ago     586MB
mysql         8.0.31    7484689f290f   21 months ago   538MB
nginx         1.17.8    a1523e859360   4 years ago     127MB
```



### 2.运行emqx 

```shell
# 指令 需要拷贝emqx:/opt/emqx/etc  获取容器拷贝文件
docker run -d --name emqx --privileged=true -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083  emqx/emqx:latest
```

结果: 

```
#win
C:\Users\Administrator>docker run -d --name emqx --privileged=true -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083  emqx/emqx:latest
35ade8e790c64c9f0b99b599df840577647b85d79cdac8a770db066e11f6abd9
#centos8 
[root@VM-20-7-opencloudos ~]# docker run -d --name emqx --privileged=true -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083  emqx/emqx:latest
4a3e678677f0b482221ad6a587bc1c435aea30a7ffd638ecbca46c4aacb52007
```

注：如果不需要挂载，后续不用操作

### 3.配置拷贝与挂载

 从临时容器内复制配置文件到挂载目录下  `docker cp < 容器name|| 容器id>`

```shell
#win
docker cp emqx:/opt/emqx/etc F:\document\0awork\docker\mqtt\emqx  # win 确保文件目录存在

#linux centos8  使用shell 创建文件夹 /root/docker/emqx
[root@VM-20-7-opencloudos ~]# ll
total 564792
drwxr-xr-x 2 root root      4096 Aug 27 09:16 jar
-rw------- 1 root root 537877504 Aug 27 09:19 jarjdk8.tar
drwxr-xr-x 2 root root      4096 Aug 27 08:48 java
drwxr-xr-x 3 root root      4096 Aug  5 16:59 lastools
drwxr-xr-x 4 root root      4096 Aug  5 21:24 minio
drwxr-xr-x 5 root root      4096 Aug  4 13:00 nginx
drwxr-xr-x 4 root root      4096 Aug  5 15:05 potree
drwxr-xr-x 4 root root      4096 Aug  5 17:39 PotreeConverter
-rwxr-xr-x 1 root root  40435082 Aug  4 15:17 vueblog-0.0.1-SNAPSHOT.jar
# 1.创建
[root@VM-20-7-opencloudos ~]# mkdir -p /root/docker/emqx
[root@VM-20-7-opencloudos ~]# docker cp emqx:/opt/emqx/etc /root/docker/emqx 
Successfully copied 177kB to /root/docker/emqx

```

你可以将拷贝的 etc保存避免下一次在拷贝

### 4.停止临时容器 删除

```shell
docker ps
docker stop 35ade8e790c6 # id||name
docker rm 35ade8e790c6
```



### 5.重新运行emqx

查看镜像 `docker images` || `docker iamge ls`  如下： `emqx/emqx:latest` 指定要运行的镜像为 “emqx/emqx” 的最新版本

```
docker run -d --restart=always --name emqx -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083 -v F:\document\0awork\docker\mqtt\emqx\etc:/opt/emqx/etc emqx/emqx:latest
# lunix
docker run -d --restart=always --name emqx -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083 -v /root/docker/emqx/etc:/opt/emqx/etc emqx/emqx:latest 
```

 - --restart=always  --privileged=true

```
docker run -d --restart=always --name emqx -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083 -v F:\document\0awork\docker\mqtt\emqx\etc:/opt/emqx/etc emqx/emqx:latest
```

这条命令是使用 Docker 来运行一个 MQTT 消息代理服务器（在这个例子中是 EMQX）的示例。下面是命令的详细解释：

- `docker run`: 这是 Docker 的一个基本命令，用于从镜像启动一个新的容器。

- `-d`: 这个参数指定 Docker 容器在后台运行（"detached" 模式）。这意味着你不会立即看到容器的输出，但容器会在后台继续运行。

- `--restart=always`: 这个参数设置容器的重启策略为“always”，意味着无论何时容器停止（无论是正常停止还是由于错误而停止），Docker 都会自动重启它。这对于需要持续运行的服务非常有用。

- `--name emqx`: 这个参数为容器指定了一个名称，即 `emqx`。这使得你可以通过名称而不是容器ID来引用容器。

- `-p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083`: 这些参数指定了端口映射。格式为 `<宿主机端口>:<容器端口>`。这允许你将容器内的端口映射到宿主机的端口上，以便可以从宿主机访问这些服务。在这个例子中，EMQX 的几个关键端口被映射到了宿主机的相应端口上：
  - 1883: MQTT 协议的默认端口，用于 TCP 连接，即MQTT 客户端与 EMQ X 服务进行通信。
  - 8883: MQTT over SSL/TLS 的端口。 MQTT 协议的安全端口，使用 SSL/TLS 加密通信。
  - 8083: HTTP API 端口。
  - 8084: MQTT WebSocket 端口。
  - 8081: MQTT WebSocket over SSL/TLS 端口（但这里可能是一个误配置，因为 EMQX 默认不使用 8081 端口，可能是为了某种特定配置）。
  - 18083: Dashboard 的 Web 界面端口。

- `-v F:\document\0awork\docker\mqtt\emqx\etc:/opt/emqx/etc`: 这个参数用于将宿主机的目录（或文件）挂载到容器内的指定位置。在这个例子中，宿主机的 `F:\document\0awork\docker\mqtt\emqx\etc` 目录被挂载到容器的 `/opt/emqx/etc` 目录。这允许你修改容器内的配置文件而不需要进入容器内部，直接修改宿主机的文件即可。

- `emqx/emqx:latest`: 这指定了要使用的 Docker 镜像的名称和标签。在这个例子中，使用的是 `emqx/emqx` 镜像的最新版本（`latest` 标签）。

综上所述，这条命令在后台启动了一个名为 `emqx` 的容器，该容器运行 EMQX MQTT 消息代理服务器，并将几个关键端口映射到宿主机的相应端口上，同时将宿主机的某个目录挂载到容器内用于配置文件的管理，并设置了容器始终自动重启的策略。

 - 上述 如果要做持久化存储 ，把数据放到宿主机上，你需要知道 emqx 各类数据 对应的位置 (如日志log、数据data)

  命令来查看 EMQX 容器的日志

```shell
docker logs emqx
```

在浏览器输入  `http://114.132.62.199:18083/` ok ,进不去看看安全组 {1883，。。。。。，18083}

# 二、部署mysql

操作流程： 是win操作，如果liunx 目录改宿主机root下  先创建对应文件


## 1. 拉取mysql 镜像

>  docker pull mysql :tag

~~~shell
docker pull mysql #默认最新 tag
docker pull mysql:5.7 #会拉取 MySQL 5.7 版本的镜像。
~~~

> 拉取镜像后，你可以使用 `docker images`  命令来查看本地已经下载的镜像列表，确认 MySQL 镜像是否成功下载。

## 2.运行mysql

> 可以使用 `docker run`>命令来运行一个 MySQL 容器实例

```shell
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```

在这个命令中，`--name some-mysql` 指定了容器的名称（你可以将其替换为你自己的名称），`-e MYSQL_ROOT_PASSWORD=my-secret-pw` 设置了 MySQL 数据库的 root 用户密码（请替换为你自己的密码），`-d` 参数让容器在后台运行，`mysql:tag` 指定了要使用的 MySQL 镜像版本（如果省略 tag，则默认为最新版本）。

请注意，为了简化命令，上面的例子中的 `mysql:tag` 应该替换为实际的镜像标签，如 `mysql:5.7`。如果使用的是最新版本的镜像，则可以直接使用 `mysql`。

展示了如何运行 MySQL 容器并将容器的 3306 端口映射到宿主机的 3307 端口上

```
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -p 3307:3306 -d mysql:tag
```

在这个命令中：

- `--name some-mysql`：指定容器的名称为 `some-mysql`（你可以根据需要更改这个名称）。
- `-e MYSQL_ROOT_PASSWORD=my-secret-pw`：设置 MySQL 数据库的 root 用户密码为 `my-secret-pw`（请替换为你自己的密码）。
- `-p 3307:3306`：将容器内的 3306 端口映射到宿主机的 3307 端口上。
- `-d`：让容器在后台运行。
- `mysql:tag`：指定要使用的 MySQL 镜像版本。`tag` 是可选的，如果不指定，则默认为最新版本。如果你想要使用特定版本的 MySQL，比如 5.7，你应该将 `tag` 替换为 `5.7`。

因此，如果你想要使用最新版本的 MySQL，命令将是：

```bash
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -p 3307:3306 -d mysql
```

如果你想要使用 MySQL 5.7 版本，命令将是：

```bash
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -p 3307:3306 -d mysql:5.7
```

执行上述命令后，MySQL 容器将在后台运行，并且你可以通过宿主机的 3307 端口来访问 MySQL 服务了。

>忘记MySQL密码代码如下（示例）：

```shell
docker inspect root-mysql-1 | grep MYSQL_ROOT_PASSWORD
docker inspect 3980a26fb9e9 | grep MYSQL_ROOT_PASSWORD  # 运行的容器 3980a26fb9e9
```

## 2.删除、停止与删除镜像 

停止容器如下（示例）：

```
docker stop 3980a26fb9e9 # 3980a26fb9e9 为运行容器  启动 start 与 重启 restart
```

删除如下（示例）：

```
docker rm 3980a26fb9e9 # 删除容器前 需要停止容器运行
docker rm -f container_id_or_name # 强制删除正在运行的容器（不推荐，因为这可能会导致数据丢失），可以添加-f（或--force）
```

删除镜像

```
docker rmi image_id_or_name 
```

Docker镜像和容器ID是唯一的，但名称可以是重复的，特别是在不同的命名空间中。因此，在指定要删除的资源时，请确保你使用的是正确的ID或名称。



# 三、部署minio

## 1. 创建文件夹

 ```
mkdir -p /root/docker/minio/data  # win 界面创建文件夹 
mkdir -p /root/docker/minio/config
 ```

这个命令在`/root/minio/`目录下创建了一个名为`data`的文件夹（如果`minio`目录不存在，则连同它一起创建）。这个文件夹将用作MinIO的数据存储目录，MinIO会将所有上传的文件保存在这里。



## 2.拉取minio 镜像

>指令如下（示例）：

```c
docker pull minio/minio
```

拉取 `docker pull minio/minio`  之前，先创建文件夹,用于拷贝 



## 3.运行minio容器

运行临时minio容器，取名minio2

```
docker run -d -p 9000:9000 -p 9090:9090 --name minio2 -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9090" 
```

注：如果不需要挂载 数据持久化，后续不用操作 

## 4.配置拷贝与挂载

```shell
docker cp minio2:/data  F:\docker\dockerc\minio # win 将临时容器minio2 的
docker cp minio2:/root/.minio  F:\docker\dockerc\minio\config
# cenntos8
 docker cp minio2:/root/.minio /root/docker/minio/config
 docker cp minio2:/data /root/docker/minio
```

删除minio2 

```
docker rm -f minio2
docker ps -a # 查看
```

重新运行

```shell
docker run -d -p 9000:9000 -p 9090:9090 -v F:\document\0awork\docker\minio\data:/data -v F:\document\0awork\docker\minio\config:/root/.minio --name minio -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9090"
```

```shell
docker run -d -p 9000:9000 -p 9090:9090 -v F:\docker\dockerc\minio\data:/data -v F:\docker\dockerc\minio\config:/root/.minio --name minio -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9090"
```



```shell
docker run -d -p 9000:9000 -p 9090:9090 -v  /root/docker/minio/data:/data -v   /root/docker/minio/config:/root/.minio --name minio -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio  server /data --console-address ":9090"
```

这个命令用于启动一个新的Docker容器，运行MinIO服务。下面是命令各部分的详细解释：

- `docker run`: Docker运行容器的命令。

- `-d`: 在后台运行容器。

- `-p 9000:9000`: 将容器的9000端口映射到宿主机的9000端口，MinIO的API和HTTP服务默认通过这个端口。

- `-p 9090:9090`: 将容器的9001端口映射到宿主机的9090端口，用于MinIO的Web控制台。

- `-v /root/minio/data:/data`: 将宿主机的`/root/minio/data`目录挂载到容器的`/data`目录，作为MinIO的数据存储位置。

- `-v /root/minio/config:/root/.minio`: 将宿主机的`/root/minio/config`目录挂载到容器的`/root/.minio`目录，用于存储MinIO的配置文件。

- `--name minio`: 设置容器的名称为`minio`。

- `-e "MINIO_ACCESS_KEY=your_access_key"`: 设置环境变量`MINIO_ACCESS_KEY`，这是MinIO的访问密钥（Access Key），你需要将其替换为你自己的密钥。

- `-e "MINIO_SECRET_KEY=your_secret_key"`: 设置环境变量`MINIO_SECRET_KEY`，这是MinIO的密钥（Secret Key），你也需要将其替换为你自己的密钥。

- `minio/minio`: 指定要运行的镜像名称。

- `server /data`: 容器启动时执行的命令，`server /data`表示启动MinIO服务，并指定`/data`目录作为数据存储位置。

- `--console-address ":9090"`: 指定MinIO Web控制台的监听地址和端口，这里指定为`:9090`，即容器内部的9090端口。

  总之，这条命令通过Docker部署了一个MinIO服务，并将其数据存储目录和配置文件目录映射到了宿主机的指定位置，同时设置了访问密钥和密钥，并通过宿主机的9000和9090端口分别提供API和Web控制台服务。

  如果是win 

  - 不使用dockers  直接下载minio.exe 使用 (后台9090端口  9000端口)

    ```shell
    minio.exe server F:\MinIo\Data --console-address ":9000" --address ":9090"
    ```

  - 使用docker

  ```shell
  docker run -d -p 9000:9000 -p 9090:9090 -v F:\document\0awork\docker\minio\data:/data -v F:\document\0awork\docker\minio\config:/root/.minio --name minio -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9090"
  ```

访问：http://192.168.124.132:9090 用户名：密码 minioadmin：minioadmin


#  四、部署redis

 ## 1. 拉取redis

```shell
docker pull redis # 默认最新
```

## 2.运行redis

拉取完镜像后，你就可以运行一个Redis容器了。以下是一个基本的命令，用于在后台运行Redis容器，并设置容器内的Redis数据持久化到宿主机的`/root/docker/redis/data `目录（注意：你需要先创建这个目录，或者Docker会自动为你创建，但出于权限考虑，手动创建通常更安全）：

```shell
mkdir -p /root/docker/redis/data 
docker run -d -p 6379:6379 --name myredis redis
docker cp myredis:/data /root/docker/redis 
## 停止容器 删除 后 重新运用
docker run --name my-redis -d -p 6379:6379 -v /root/docker/redis/data :/data redis
docker run -d --restart=always --name my-redis -d -p 6379:6379 -v /myredis/data:/data redis  # 重启docker 就会启动 redis
```

对于刚拉取的redis ,运行容器下data 一般都是空，对于上述无需做临时容器

```
docker pull redis # 默认最新
mkdir -p /root/docker/redis/data 

docker run --name my-redis -d -p 6379:6379 -v /root/docker/redis/data :/data redis
#或
docker run -d --restart=always --name my-redis -d -p 6379:6379 -v /myredis/data:/data redis  # 重启docker 就会启动 redis
```

# 五、run 常用指令符

### 1. --restart=always

`--restart=always`这个参数的含义如下： 当容器因为各种原因（比如意外崩溃、被手动停止后又启动 Docker 服务等）退出时，Docker 引擎会自动尝试重新启动这个容器。 这对于需要持续运行的服务非常有用。例如，你运行一个消息队列服务（如 EMQX），希望它在任何情况下都能保持运行状态，即使出现一些临时的问题导致容器退出，Docker 也会自动将其重新启动，以确保服务的高可用性。 这样可以减少人工干预的需求，提高系统的稳定性和可靠性。如果没有这个参数，容器退出后就会保持停止状态，需要手动启动它才能继续提供服务。

使用`docker update`命令更新容器配置

```shell
docker stop mysql8
docker update --restart=always mysql8
```



### 2.  --privileged=true

在 Docker 中，`--privileged=true`参数的意思是给予容器特权模式。 具体解释如下： **一、特权模式的作用** 容器在默认情况下是受到很多限制的，以保证安全性。但使用特权模式后： 1. 容器可以访问主机上的所有设备，可以进行一些需要直接访问硬件设备的操作。例如，容器可以直接访问主机的磁盘、网络设备等。 2. 容器内的进程可以执行一些通常只有内核才能执行的操作，比如修改主机的网络设置、挂载文件系统等。 **二、使用特权模式的风险** 虽然特权模式在某些特定场景下很有用，但也带来了很大的安全风险。因为容器内的进程拥有了过高的权限，如果容器被攻击者攻破，可能会导致主机系统受到严重的破坏。 所以，在使用`--privileged=true`时需要谨慎考虑，确保容器的安全性和可靠性，并且仅在确实需要这些高级权限的情况下才使用特权模式。

### 3. -v

在 Docker 命令中，“-v”或“--volume”用于将宿主机的目录或文件挂载到容器中。 具体来说，它有以下几个重要作用： 

**一、数据持久化** 

1. 确保数据安全：容器在运行过程中可能会生成重要的数据，如果不进行数据持久化，当容器被删除或重新创建时，这些数据将会丢失。通过将容器内的特定目录挂载到宿主机的目录，可以将数据保存在宿主机上，即使容器不存在了，数据依然可以保留。
2. 方便备份和恢复：宿主机上的目录可以更容易地进行备份操作，以便在需要时恢复数据。

 **二、配置灵活性**

1. 便于修改配置：可以将容器内的配置文件所在目录挂载到宿主机上，这样就可以直接在宿主机上修改配置文件，而无需进入容器内部进行操作。这对于需要频繁调整配置的场景非常方便。 
2. 不同环境配置复用：可以在不同的宿主机上使用相同的挂载目录，从而实现配置的复用。例如，开发环境和生产环境可以使用相同的宿主机挂载目录来存放配置文件，方便进行配置的统一管理和切换。 例如，“-v /host/path:/container/path”表示将宿主机上的“/host/path”目录挂载到容器内的“/container/path”目录。这样，容器内对“/container/path”目录的读写操作实际上是对宿主机上“/host/path”目录的操作。

  ### 4.  --network

> 在 Docker 环境中，网络是实现容器之间以及容器与外部世界通信的关键部分。不同的网络设置可以满足不同的应用场景需求。

这个参数用于指定容器运行时所连接的网络。通过指定特定的网络，可以控制容器的网络隔离程度、访问权限以及与其他容器或外部服务的通信方式

1.Docker 网络创建的基本命令格式如下：

```shell
docker network create [OPTIONS] NETWORK
docker network create --driver bridge my-custom-network
# 查看网络列表
docker network ls # 查看自定义的my-custom-network
docker network rm my-custom-network
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



### 5. 查找重启策略

可能的重启策略还包括 `no`、`on-failure` 和 `unless-stopped`，你可以根据实际输出判断当前设置的状态。

在 Docker 中，重启策略用于控制容器在退出时的行为。以下是每种重启策略的解释：

1. **no**：
   - 这是默认设置。如果容器退出，Docker 不会重启它。这意味着容器在停止后不会自动重启。

2. **on-failure**：
   - 如果容器因错误退出（即退出状态非 0），Docker 会重启它。您可以指定最大重启次数。例如，`--restart=on-failure:5` 表示如果容器失败（退出状态非 0），Docker 将最多重启 5 次。
   - 如果容器正常退出（退出状态为 0），则不会重启容器。

3. **always**：
   - 不论容器是正常退出还是因错误退出，Docker 都会重启容器。即使 Docker 服务重新启动，容器也会自动重启。这通常用于需要始终运行的后台服务。

4. **unless-stopped**：
   - 类似于 `always`，但有一个区别。如果容器被手动停止（使用 `docker stop` 命令），Docker 不会在 Docker 服务重启后自动重启该容器。当 Docker 服务重新启动时，只有未被停止的容器会被重启。

通过这些策略，您可以根据需要自定义容器的重启行为，以更好地管理容器化应用的可用性和稳定性。

如果你想在不删除原有容器的情况下为其添加重启策略，可以使用 `docker update` 命令。以下是步骤：

1. **更新容器的重启策略**：
   使用以下命令将容器的重启策略更新为 `always`。假设你的容器名称是 `emqx`：

   ```bash
   docker update --restart=always emqx
   ```

2. **验证更改**：
   你可以通过以下命令验证容器的重启策略是否已成功更新：

   ```bash
   docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' emqx
   ```

如果输出是 `always`，则表示重启策略已成功更改。

这样你就可以在不删除容器的情况下成功设置重启策略。

![image-20240928154419939](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20240928154419939.png)

   

#  五、镜像离线

```
mkdir /root/images
离线 
docker save -o [保存文件全路径] [镜像名称]:[镜像版本]
docker save -o /root/images/mysql-8.0.31.tar mysql:8.0.31 
docker save -o /root/images/redis.tar a82a8f162e18 # imageId
docker save -o F:\document\p\mysql-8.0.31.tar mysql:8.0.31 # mysql离线例子

docker save openjdk:8 > /root/tar/openjdk8.tar

docker load命令 
   docker load -i F:\document\p\mysql-8.0.31.tar
   docker run -p 3306:3306 --name some-mysql -e MYSQL_ROOT_PASSWORD=your_password mysql:8.0.31
```



# 六、dockerFile





# 七、docker-compose 

---

# 总结

`提示：这里对docker常用指令进行总结：`

如果要做持久化存储 ，把数据放到宿主机上，你需要知道 你的容器 各类数据 对应的位置 (如日志log、数据data)

在端口映射时，注意宿主机端口是否被占用，如果是云服务器 可能会存在防火墙，需要将对应端口开启。

```
docker search minio #
docker --version # 
docker version

docker ps # 

docker image ls #

docker rmi 07520491faf1 # 07520491faf1 是要删除的镜像的 ID,在执行此命令之前，请确保该镜像没有被任何容器使用，否则可能会删除失败。如果有容器正在使用该镜像，可以先停止并删除相关容器，然后再删除镜像 如下：
[root@VM-20-7-opencloudos ~]# docker rmi a82a8f162e18
Error response from daemon: conflict: unable to delete a82a8f162e18 (cannot be forced) - image is being used by running container 3980a26fb9e9


```

启动Docker服务，并设置其为开机自启。

```shell
sudo systemctl start docker  
sudo systemctl enable docker #
```

使用 systemctl 命令停止 Docker 服务：

```shell
   sudo systemctl stop docker
```

禁止 Docker 服务在系统启动时自动启动：

```shell
   sudo systemctl disable docker
```
