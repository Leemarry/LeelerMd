要在Docker启动时自动启动Redis（或其他任何Docker容器），你需要依赖于Docker的容器管理策略或者更高级别的容器编排工具，如Docker Compose、Kubernetes等。但是，对于简单的场景，如果你只是希望Docker在启动时（比如系统启动后）自动启动Redis容器，你可以通过几种方法来实现：

### 1. 使用Docker的系统服务（适用于Linux）

在Linux系统上，你可以通过创建一个systemd服务单元（service unit）或者init.d脚本来让Docker在启动时自动运行Redis容器。但是，这通常不是直接启动容器，而是启动Docker服务本身，并依赖于Docker Compose或其他脚本来管理容器的启动。

不过，如果你的Docker服务已经配置为在系统启动时自动启动，你可以通过Docker Compose（如果你使用它）来管理Redis容器的启动。

### 2. 使用Docker Compose

Docker Compose是一个用于定义和运行多容器Docker应用程序的工具。你可以使用Docker Compose来编写一个`docker-compose.yml`文件，该文件描述了你的应用程序服务（在这个例子中是Redis），然后让Docker Compose在启动时自动运行这些服务。

首先，创建一个`docker-compose.yml`文件，内容如下：

```yaml
version: '3'
services:
  redis:
    image: redis
    ports:
      - "6379:6379"
    volumes:
      - /myredis/data:/data
    restart: always  # 这将确保容器总是重新启动，除非明确停止
```

然后，你可以通过以下命令启动Redis服务（注意：第一次运行会创建并启动容器）：

```bash
docker-compose up -d
```

如果Docker Compose服务被配置为系统服务（这取决于你的系统和Docker Compose的安装方式），它将在系统启动时自动运行，并启动所有定义的服务，包括Redis。

### 3. 使用Cron或其他定时任务（不推荐）

虽然可以使用Cron作业或其他定时任务在系统启动时运行Docker命令来启动Redis容器，但这不是最佳实践。这种方法不如使用systemd服务或Docker Compose那样健壮和可靠。

### 4. 依赖Docker的重启策略

在Docker容器配置中，你可以设置重启策略（如`restart: always`），这样当Docker守护进程重启时，容器也会自动重启。但是，这依赖于Docker服务本身的启动，而不是直接在系统启动时启动容器。

### 结论

对于大多数生产环境，建议使用Docker Compose结合系统服务管理（如systemd）来确保Redis容器在系统启动时自动启动，并能够在系统重启后恢复。如果你正在使用Kubernetes等容器编排工具，那么这些工具提供了更强大和灵活的机制来管理容器的生命周期。