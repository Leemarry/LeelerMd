如果你想查看 Docker 容器中当前挂载的卷和它们的路径，可以使用以下命令：

1. **查看容器的具体信息**：
   使用 `docker inspect` 命令来查看容器的详细信息，包括挂载的卷：
   ```bash
   docker inspect nginx
   ```
   这会输出容器的 JSON 格式的详细信息。你可以在输出中找到 `"Mounts"` 部分，其中列出了所有挂载的源路径和目标路径。

2. **使用 `docker exec` 进入容器**：
   进入容器之后，你可以通过命令行直接查看挂载目录中的文件。首先，你可以用以下命令进入容器：
   ```bash
   docker exec -it nginx /bin/bash
   ```
   或者，如果容器中没有安装 `bash`，可以尝试：
   ```bash
   docker exec -it nginx /bin/sh
   ```

   进入容器后，可以查看 `/usr/share/nginx/` 目录，确认配置文件和其他文件：
   ```bash
   ls /usr/share/nginx/
   ```

3. **查看 Nginx 配置文件中的具体设置**：
   如果你主要想查看 Nginx 的配置，可以直接查看 `/etc/nginx/nginx.conf` 和 `/etc/nginx/conf.d/` 目录下的文件，通过以下命令：
   ```bash
   cat /etc/nginx/nginx.conf
   ls /etc/nginx/conf.d/
   ```

使用这些方法可以帮助你确认在 Docker 容器中挂载了哪些配置文件及其具体内容。

```
exit
```