@[TOC](docker部署)

# docker

安装 Docker
首先，确保您的系统上已经安装了 Docker。您可以参考 Docker 官方文档获取适合您操作系统的安装指南。 下面以Centos8 做案例 并 补充对应 win 命令 

镜像推荐 "https://docker.rainbond.cc",

```powershell
  "registry-mirrors": [
    "https://registry.hub.docker.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://registry.docker-cn.com"
  ]
```


## docker-nginx

我以nginx为例子，说明 在root创建nginx文件夹

### 1.1、拉取镜像 查看版本

在终端或命令提示符中，运行以下命令来拉取最新的 Nginx 官方镜像： `docker pull nginx # 默认最新`

```powershell
docker pull nginx # 默认最新
docker pull nginx:1.17.8 # 指定版本 下面案例以1.17.8
docker images # 查看版本
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/1255fbd4adb049bca0cc876b3a4d5a27.png)

### 1.2、 在root创建nginx文件夹

```powershell
 mkdir -p /root/nginx/html  # win 创建如下
 mkdir -p /root/nginx/conf 
 mkdir -p /root/nginx/logs
```
> win如下：

![image-20240911102505612](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20240911102505612.png)








 ###  1.3、  运行 nginx 容器 

 要在 Docker 中运行 nginx ，您可以使用以下命令：

```powershell
sudo docker run --name nginx178 -p 80:80 -d nginx:1.17.8
docker run --name nginx178 -p 80:80 -d nginx:1.17.8 # win
```

-d 选项表示以守护式（后台）模式运行容器。
-p 80:80 用于将主机的 80 端口映射到容器内的 80 端口，这样您就可以通过主机的 80 端口访问容器内运行的 nginx 服务。
例如，如果您的服务器上已经运行了其他占用 80 端口的服务，您可能需要将映射端口修改为其他未被占用的端口，比如 -p 8080:80 ，然后通过 http://<主机 IP>:8080 来访问 nginx 服务。
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/3b3141cac75c4918926aaa9da450b45b.png)

```powershell
docker stop nginx178 # 停止 --name nginx178  容器 或者 docker stop 110ab8a429d0
```

要重新运行之前使用 docker stop 命令停止的名为 nginx178 的容器，您可以使用以下命令：

```powershell
docker start nginx178
```

要删除名为 nginx178 的容器，您可以使用以下命令：

```powershell
docker rm nginx178
```

启动nginx178 容器 

```powershell
  docker start nginx178
  docker ps
```

### 1.4、 拷贝配置文件 

 如果您需要将容器内的文件或目录拷贝到本地，使用以下命令格式：

```powershell
 # 从容器复制到本地-》》 前提容器需要启动
 docker cp 容器名称:容器内路径 本地路径
 docker cp nginx178:/etc/nginx/nginx.conf /root/nginx/conf/nginx.conf
 .... 仿照上述与下面win指令 写对应 html、logs
```

`window` 我需要拷贝到的盘符    `F:\docker\dockerc\nginx\conf` 主要拷贝这个 `nginx.conf` 也可以拷贝 `html` 与 `/var/cache/nginx`  下的缓存 `/var/log/nginx` 下的日志

```powershell
docker cp nginx178:/etc/nginx/nginx.conf  F:\docker\dockerc\nginx\conf\nginx.conf
docker cp nginx178:/usr/share/nginx/html  F:\docker\dockerc\nginx\
docker cp nginx178:/var/log/nginx F:\docker\dockerc\nginx\logs 
# linux 
```

停止并删除 nginx178 容器 ： 

```powershell
docker stop nginx178
docker rm nginx178
```

### 1.5、  映射端口映射与挂载

> 注意：指定容器应该连接到哪个网络 ，创建网络 `docker network create --driver bridge my-custom-network`   运行时添加 ` --network=my-custom-network `
>
> ```
> docker run -d --name cloud-container -p 8085:8085 2567088e354e # 该指令
> ## --network=my-custom-network：这个选项用于指定容器应该连接到哪个网络 ,我自定义名字就叫my-custom-network,用于将多个容器关联到t
> docker network create --driver bridge my-custom-network
> docker run -d --network=my-custom-network --name cloud-container -p 8085:8085 2567088e354e #  --network=my-custom-network
> ```
>
> 

```powershell
   docker run -d -p 9099:99  -p 80:80 -p 443:443 --network=my-custom-network --name nginx178 -v /root/nginx/html:/usr/share/nginx/html -v /root/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /root/nginx/logs:/var/log/nginx --privileged=true nginx:1.17.8
```

> linux

```
   docker run -d -p 9099:99  -p 80:80 -p 443:443 --name nginx178 -v /root/nginx/html:/usr/share/nginx/html -v /root/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /root/nginx/logs:/var/log/nginx --privileged=true nginx:1.17.8
```

**-v /root/nginx/cache:/var/cache/nginx \  # 映射缓存目录   需要提前创建**

这段 `Docker` 命令的含义如下：

- `docker run` ：表示运行一个新的 `Docker` 容器。
- `-d` ：以守护式（后台）模式运行容器。
- `-p 9099:99 -p 80:80 -p 443:443` ：将主机的 `9099` 端口映射到容器内的 `99` 端口，`80` 端口与容器内的 `80` 端口映射，`443` 端口与容器内的 `443` 端口映射，以便通过主机端口访问容器内相应端口提供的服务。
- `--name nginx178` ：为容器命名为 `nginx178` ，方便后续对该容器进行管理和操作。
- `-v /root/nginx/html:/usr/share/nginx/html` ：将主机的 `/root/nginx/html` 目录挂载到容器内的 `/usr/share/nginx/html` 目录，使得容器可以访问主机上该目录中的网页文件。
- `-v /root/nginx/conf/nginx.conf:/etc/nginx/nginx.conf` ：将主机的 `/root/nginx/conf/nginx.conf` 配置文件挂载到容器内的 `/etc/nginx/nginx.conf` 位置，使用自定义的配置文件来配置容器内的 `nginx` 服务。
- `-v /root/nginx/logs:/var/log/nginx` ：将主机的 `/root/nginx/logs` 目录挂载到容器内的 `/var/log/nginx` 目录，使容器内 `nginx` 产生的日志能存储在主机的指定目录中。
- `--privileged=true` ：给予容器特权权限。
- `nginx:1.17.8` ：指定要使用的 `nginx` 镜像版本为 `1.17.8` 。

例如，如果您在主机的 `/root/nginx/html` 目录中放置了自定义的网页文件，通过上述挂载配置，容器内的 `nginx` 服务就能提供这些自定义的网页；如果您修改了主机上的 `/root/nginx/conf/nginx.conf` 配置文件，容器内的 `nginx` 服务会应用这些修改后的配置。 

> window:  

这里我已经创建了 网络，name就是 `my-custom-network`,  容器名为 `nginx178`

```powershell
docker run -d -p 8090:90  -p 80:80 -p 443:443 --network=my-custom-network  --name nginx178  -v F:\docker\dockerc\nginx\html:/usr/share/nginx/html -v F:\docker\dockerc\nginx\conf\nginx.conf:/etc/nginx/nginx.conf -v F:\docker\dockerc\nginx\logs:/var/log/nginx --privileged=true nginx:1.17.8
```

>   启动成功 使用80 端口会出现 `nginx-403` 原因 宿主机的挂载文件html 没有拷贝 index.html ，使用 8090 会出现 `该网页无法正常运作`  原因是 nginx.conf没有配置8090 
>   ![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/03a3a0e969294a66a6d9d407c1d36119.png)

这段 `Docker` 命令的注意的是：  `/usr/share/nginx/www/`  这个在 ngin.conf 是容器内部的绝对位置 而不是宿主机的绝对位置

如果容器内没有 `/usr/share/nginx/www` 目录，而宿主机上有 `/root/nginx/www` 目录，执行这个 `-v /root/nginx/www:/usr/share/nginx/www` 挂载操作通常不会有问题。

当执行挂载时，如果容器内的目标路径不存在，Docker 会自动创建该目录，并将宿主机目录中的内容映射到新创建的容器目录中。

例如，如果您后续在宿主机的 `/root/nginx/www` 目录中添加或修改文件，这些更改将在容器内的 `/usr/share/nginx/www` 目录中可见。 

### 1.6、  离线包

docker save -o [保存文件全路径] [镜像名称]:[镜像版本]

```powershell
 docker save -o /Users/Aion/mysql-8.0.31.tar mysql:8.0.31 
  docker save -o /Users/Aion/mysql-8.0.31.tar mysql:8.0.31 
 docker save -o F:\docker\dockeri\mysql-8.0.31.tar mysql:8.0.31  // 将 包 保存到  F:\docker\dockeri\mysql-8.0.31.tar
```

```
docker save -o  F:\docker\dockeri\nginx.tar nginx:1.17.8
```

docker load 加载命令 

```powershell
   docker load -i F:\docker\dockeri\mysql-8.0.31.tar
   docker run -p 3306:3306 --name some-mysql -e MYSQL_ROOT_PASSWORD=your_password mysql:8.0.31
```

## centos-nginx

nginx 服务没有安装。您可以通过包管理器（如 yum ）来安装 nginx 。
对于 CentOS 系统，使用以下命令安装：

```powershell
sudo yum install nginx
```

Nginx默认目录
输入命令：

```powershell
whereis nginx
nginx: /usr/sbin/nginx /usr/lib64/nginx /etc/nginx /usr/share/nginx /usr/share/man/man8/nginx.8.gz /usr/share/man/man3/nginx.3pm.gz
```

`whereis nginx` 命令用于查找指定命令（在本例中是 `nginx` ）的相关文件路径。

输出的信息解释如下：

- `/usr/sbin/nginx` ：这通常是 `nginx` 二进制可执行文件的位置。
- `/usr/lib64/nginx` ：可能存放与 `nginx` 相关的库文件。
- `/etc/nginx` ：是 `nginx` 配置文件的存放目录。
- `/usr/share/nginx` ：可能包含 `nginx` 的共享数据，例如默认的网页文件等。
- `/usr/share/man/man8/nginx.8.gz` 和 `/usr/share/man/man3/nginx.3pm.gz` ：是 `nginx` 的手册页文件。

例如，如果您想要修改 `nginx` 的配置，您就需要到 `/etc/nginx` 目录中操作相关的配置文件`nginx.conf`。 
![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/ae3d8c7d59d84c569fb66855c711ea32.png)


在 CentOS 系统中，使用 sudo yum install nginx 安装完 Nginx 后，可以通过以下命令启动 Nginx 服务：
sudo systemctl start nginx

```powershell
sudo systemctl start nginx
```

如果您想让 Nginx 服务在系统启动时自动启动，可以使用以下命令：

```powershell
sudo systemctl enable nginx
```

要检查 Nginx 服务的状态，可以使用：
systemctl status nginx

```powershell
systemctl status nginx
```

要停止 Nginx 服务，可以使用：
sudo systemctl stop nginx

```powershell
sudo systemctl stop nginx
```

要删除 Nginx 服务，可以使用：
sudo yum remove nginx

```powershell
sudo yum remove nginx
```

nginx.conf 文件:https://wwat.lanzoul.com/iwfmW29qhgyf


## emqx 部署

## minio 、 redis 、 emqx 、 mysql  和 jar（tomcat) 部署

 emqx 部署: [ emqx 部署](https://www.csdn.net/)

###   还没有来得及就写  有问题评论区留言

如果你想尝试使用此编辑器, 你可以在此篇文章任意编辑。当你完成了一篇文章的写作, 在上方工具栏找到 **文章导出** ，生成一个.md文件或者.html文件进行本地保存。

### 导入

如果你想加载一篇你写过的.md文件，在上方工具栏可以选择导入功能进行对应扩展名的文件导入，
继续你的创作。

[1]: http://meta.math.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference
[2]: https://mermaidjs.github.io/
[3]: https://mermaidjs.github.io/
[4]: http://adrai.github.io/flowchart.js/