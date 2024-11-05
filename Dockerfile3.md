# Dockerfile 开发使用手册

## 一、引言

Dockerfile 是一种用于定义 Docker 容器镜像的文本文件。通过编写 Dockerfile，开发人员可以轻松地创建可重复、可移植的容器环境，确保应用程序在不同的环境中都能一致地运行。本手册将详细介绍 Dockerfile 的基本语法和使用方法，帮助你更好地利用 Docker 进行应用开发。

## 二、Dockerfile 基本语法

### 1. 指令介绍

- **FROM**：指定基础镜像，后续的指令将基于这个镜像进行构建。
- **RUN**：在构建镜像时执行的命令，可以是任何 shell 命令或脚本。
- **COPY**：将本地文件或目录复制到镜像中。
- **ADD**：功能类似于 COPY，但可以自动解压压缩文件。
- **ENV**：设置环境变量。
- **EXPOSE**：声明容器运行时监听的端口。
- **WORKDIR**：设置工作目录。
- **CMD**：指定容器启动时要执行的命令。

### 2. 指令示例

以下是一个简单的 Dockerfile 示例：

```dockerfile
# 指定基础镜像为 ubuntu:latest
FROM ubuntu:latest

# 设置环境变量
ENV APP_HOME=/app

# 设置工作目录
WORKDIR $APP_HOME

# 安装必要的软件
RUN apt-get update && apt-get install -y python3 python3-pip

# 将本地代码复制到镜像中
COPY. $APP_HOME

# 安装项目依赖
RUN pip install -r requirements.txt

# 暴露容器端口
EXPOSE 8000

# 容器启动时执行的命令
CMD ["python3", "app.py"]
```



以下是一个jar实战的 Dockerfile 示例 ：

```dockerfile
FROM openjdk:8 # 

EXPOSE 8085

ADD UavPointCloudServer.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
```

注:  将dockerfile 与 jar 放到特意目录下，并进入该目录构建

## 三、构建镜像

使用以下命令可以根据 Dockerfile 构建镜像：

```bash
docker build -t <image_name>:<tag>.
```

其中，`<image_name>` 是你为镜像指定的名称，`<tag>` 是镜像的标签（可选）。`.` 表示 Dockerfile 所在的目录。

```
docker build -t cloud1 .
```



## 四、运行容器

构建好镜像后，可以使用以下命令运行容器：

```bash
docker run -p <host_port>:<container_port> <image_name>:<tag>
```

其中，`<host_port>` 是主机上的端口，`<container_port>` 是容器中暴露的端口，`<image_name>` 和 `<tag>` 与构建镜像时指定的名称和标签一致。



```shell

docker run -d --name cloud-container -p 8085:8085 2567088e354e # 该指令
## --network=my-custom-network：这个选项用于指定容器应该连接到哪个网络 ,我自定义名字就叫my-custom-network,用于将多个容器关联到t
docker network create --driver bridge my-custom-network
docker run -d --network=my-custom-network -v F:\docker\dockerc\nginx\html:/data/efuav --name cloud-container -p 8099:8088 uavsc #  --network=my-custom-network
```

注:  docker run 会运行该容器（cloud-container），容器存在需要测试连接的redis,mysql容器，先要运行。后面会介绍docker-compose

## 五、常见问题及解决方法

### 1. 镜像构建失败

- 检查 Dockerfile 中的指令是否正确，特别是路径和命令是否准确。
- 确保所需的文件和依赖都能被正确复制到镜像中。

### 2. 容器启动失败

- 检查容器启动时执行的命令是否正确，是否缺少必要的参数。
- 确认容器暴露的端口是否与应用程序使用的端口一致。

### 3. 资源限制问题

- 如果容器占用过多资源，可以使用 `--memory` 和 `--cpus` 选项限制容器的内存和 CPU 使用量。
- 多好多好

### 4. docker build 是否加 点（`.`）

- Dockerfile 在当前目录下

  如果你的 Dockerfile 文件位于你执行 `docker build` 命令的同一目录下，并且你没有通过 `-f` 或 `--file` 标志来指定 Dockerfile 的路径，那么你可以在命令的末尾加上一个点（`.`）。这个点代表当前目录，Docker 会在这个目录下查找 Dockerfile。

  ```shell
  docker build .
  ```

  

- Dockerfile 不在当前目录下

  如果你的 Dockerfile 不在当前目录下，你需要使用 `-f` 或 `--file` 标志来指定 Dockerfile 的路径，并且还需要指定一个上下文目录（context directory），这个目录是 Docker 用来查找 Dockerfile 中引用的任何文件（如 COPY 指令中的文件）的。这个上下文目录可以是一个点（`.`），但通常你会指定一个包含 Dockerfile 的目录。

  ```
  docker build -f /path/to/Dockerfile /path/to/context
  ```

  在这个例子中，`/path/to/Dockerfile` 是 Dockerfile 的路径，`/path/to/context` 是上下文目录，它应该包含 Dockerfile 中引用的所有文件。

- 如果 Dockerfile 在当前目录下，并且你没有使用 `-f` 标志，那么 `docker build .` 是正确的命令。 

## 六、总结

Dockerfile 是 Docker 容器化开发的重要工具，通过合理编写 Dockerfile，可以轻松构建出高效、可移植的容器环境。在开发过程中，要注意指令的正确使用和资源的合理分配，以确保应用程序在容器中稳定运行。希望本手册能帮助你更好地掌握 Dockerfile 的使用方法，提高开发效率。