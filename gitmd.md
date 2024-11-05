# docker部署目录

` 提示：工作中使用docker拉取运行镜像`
例如：部署emqx、  部署mysql 、部署minio

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

docker run -d --name emqx --privileged=true -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083  emqx/emqx:latest
```

参数 `--privileged=true` 表示赋予容器特权，用于需要与主机系统交互的操作。
参数 `-p` 指定了端口映射，将容器内的端口映射到主机上，以便可以从外部访问 EMQ X 服务。
参数 `emqx/emqx:latest` 表示使用 `emqx/emqx` 仓库中最新版本的镜像运行容器


只要是为了容器内外共享数据或持久化存储容器内的数据。通过挂载文件目录，可以将主机系统上的文件或目录与容器内部的文件系统进行关联，使得容器内的操作可以直接影响主机系统上的文件，也可以使主机系统上的文件在容器内保持持久化，即使容器被删除或重建，数据仍然保留。这样做可以方便地进行数据备份、共享和管理

```powershell
mkdir -p /home/jaxf/emqx/etc /home/jaxf/emqx/lib /home/jaxf/emqx/data /home/jaxf/emqx/log
```

这个指令需要注意，如果你是在根目录进行输入，一定要包含全部的路径名称。
如果已经在你想要指定创建的文件夹里面，只需要指定要创建的文件夹名称即可。

从临时容器内复制配置文件到挂载目录下

```powershell
docker cp emqx:/opt/emqx/etc F:\document\0awork\docker\mqtt\emqx
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
  - 1883: MQTT 协议的默认端口，用于 TCP 连接。
  - 8883: MQTT over SSL/TLS 的端口。
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



# 二、部署mysql


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
mkdir -p /root/minio/data  # win 界面创建文件夹
 ```

这个命令在`/root/minio/`目录下创建了一个名为`data`的文件夹（如果`minio`目录不存在，则连同它一起创建）。这个文件夹将用作MinIO的数据存储目录，MinIO会将所有上传的文件保存在这里。



## 2.拉取minio 镜像

>指令如下（示例）：

```c
docker pull minio/minio
```

拉取 `docker pull minio/minio`  之前，



## 3.运行minio容器

```bash
docker run -d -p 9000:9000 -p 9001:9001 -v /root/minio/data:/data -v /root/minio/config:/root/.minio --name minio -e "MINIO_ACCESS_KEY=your_access_key" -e "MINIO_SECRET_KEY=your_secret_key" minio/minio server /data --console-address ":9001"
```

这个命令用于启动一个新的Docker容器，运行MinIO服务。下面是命令各部分的详细解释：

- `docker run`: Docker运行容器的命令。

- `-d`: 在后台运行容器。

- `-p 9000:9000`: 将容器的9000端口映射到宿主机的9000端口，MinIO的API和HTTP服务默认通过这个端口。

- `-p 9001:9001`: 将容器的9001端口映射到宿主机的9001端口，用于MinIO的Web控制台。

- `-v /root/minio/data:/data`: 将宿主机的`/root/minio/data`目录挂载到容器的`/data`目录，作为MinIO的数据存储位置。

- `-v /root/minio/config:/root/.minio`: 将宿主机的`/root/minio/config`目录挂载到容器的`/root/.minio`目录，用于存储MinIO的配置文件。

- `--name minio`: 设置容器的名称为`minio`。

- `-e "MINIO_ACCESS_KEY=your_access_key"`: 设置环境变量`MINIO_ACCESS_KEY`，这是MinIO的访问密钥（Access Key），你需要将其替换为你自己的密钥。

- `-e "MINIO_SECRET_KEY=your_secret_key"`: 设置环境变量`MINIO_SECRET_KEY`，这是MinIO的密钥（Secret Key），你也需要将其替换为你自己的密钥。

- `minio/minio`: 指定要运行的镜像名称。

- `server /data`: 容器启动时执行的命令，`server /data`表示启动MinIO服务，并指定`/data`目录作为数据存储位置。

- `--console-address ":9001"`: 指定MinIO Web控制台的监听地址和端口，这里指定为`:9001`，即容器内部的9001端口。

  总之，这条命令通过Docker部署了一个MinIO服务，并将其数据存储目录和配置文件目录映射到了宿主机的指定位置，同时设置了访问密钥和密钥，并通过宿主机的9000和9001端口分别提供API和Web控制台服务。

  如果是win 

  - 不使用dockers  直接下载minio.exe 使用 (后台9090端口  9000端口)

    ```shell
    minio.exe server F:\MinIo\Data --console-address ":9000" --address ":9090"
    ```

  - 使用docker

  ```shell
  docker run -d -p 9009:9000 -p 9001:9001 -v F:\document\0awork\docker\minio\data:/data -v F:\document\0awork\docker\minio\config:/root/.minio --name minio -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9001"
  ```




#  四、部署redis

 ## 1. 拉取redis

```shell
docker pull redis # 默认最新
```

## 2.运行redis

拉取完镜像后，你就可以运行一个Redis容器了。以下是一个基本的命令，用于在后台运行Redis容器，并设置容器内的Redis数据持久化到宿主机的`/myredis/data`目录（注意：你需要先创建这个目录，或者Docker会自动为你创建，但出于权限考虑，手动创建通常更安全）：

```shell
mkdir -p /myredis/data  
docker run --name my-redis -d -p 6379:6379 -v /myredis/data:/data redis
docker run -d --restart=always --name my-redis -d -p 6379:6379 -v /myredis/data:/data redis  # 重启docker 就会启动 redis
```



---

# 总结

`提示：这里对docker常用指令进行总结：`

如果要做持久化存储 ，把数据放到宿主机上，你需要知道 你的容器 各类数据 对应的位置 (如日志log、数据data)

在端口映射时，注意宿主机端口是否被占用，如果是云服务器 可能会存在防火墙，需要将对应端口开启。

```
docker --version # 
docker version

docker ps # 

docker image ls #

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



如果需要离线包

```
离线 

docker save -o [保存文件全路径] [镜像名称]:[镜像版本]
docker save -o /Users/Aion/mysql-8.0.31.tar mysql:8.0.31
docker save -o F:\document\p\mysql-8.0.31.tar mysql:8.0.31 # mysql离线例子
docker save -o  D:\DockerImage\nginx.tar nginx:1.17.8 # 

docker save openjdk:8 > /root/tar/openjdk8.tar

docker load命令 
   docker load -i F:\document\p\mysql-8.0.31.tar
   docker run -p 3306:3306 --name some-mysql -e MYSQL_ROOT_PASSWORD=your_password mysql:8.0.31
```

--restart=always  --privileged=true

使用`docker update`命令更新容器配置

```shell
docker stop mysql8
docker update --restart=always mysql8
```

