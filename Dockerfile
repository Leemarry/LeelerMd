如果 `your_jar_filename.jar` 和 `Dockerfile` 都位于根文件夹（我们称之为 `/root` 或仅仅是根目录的某个项目目录，但通常不建议在 `/root` 下进行项目操作，因为 `/root` 是 Linux 系统中 root 用户的家目录）下的 `java` 文件夹里面，你不需要先进入 `java` 文件夹来执行 `docker build` 命令。相反，你应该在 `java` 文件夹的父目录中执行 `docker build` 命令，并指定 Dockerfile 的路径（如果它不在当前目录下）。

然而，在这个特定的情况下，因为 `Dockerfile` 和 `your_jar_filename.jar` 都在同一个 `java` 文件夹内，你只需要确保在 `java` 文件夹的父目录中执行 `docker build` 命令，并且使用 `-f` 标志来指定 `Dockerfile` 的路径（尽管在这个例子中，你也可以不使用 `-f` 标志，如果你先 `cd` 到 `java` 文件夹中再执行 `docker build` 的话，但这并不是必需的）。

这里是你可以遵循的步骤：

1. **确保你的目录结构如下**：

   ```
   /your-project-root/
   |-- java/
       |-- Dockerfile
       |-- your_jar_filename.jar
   ```

   注意：`/your-project-root/` 是你的项目根目录，它不应该是 `/root`，因为 `/root` 是系统级的目录，通常用于 root 用户。

2. **在 `java` 文件夹的父目录中执行 `docker build`**：

   ```bash
   cd /your-project-root/
   docker build -t myapp:latest -f java/Dockerfile .
   ```

   或者，如果你不想使用 `-f` 标志（尽管在这种情况下它是可选的，因为 Dockerfile 就在你要构建的上下文目录中），你可以先进入 `java` 文件夹：

   ```bash
   cd /your-project-root/java/
   docker build -t myapp:latest .
   ```

   但请注意，在第二种情况下，`.` 指的是当前目录（即 `java` 文件夹），而 Dockerfile 就在这个目录下，所以 Docker 会自动找到并使用它。

3. **确保 Dockerfile 正确**：

   你的 Dockerfile 应该类似于这样（注意，这里假设 `your_jar_filename.jar` 直接位于 Dockerfile 所在的目录中）：

   ```Dockerfile
   FROM openjdk:11-jre-slim
   WORKDIR /app
   COPY your_jar_filename.jar /app/app.jar
   ENTRYPOINT ["java","-jar","/app/app.jar"]
   EXPOSE 8080
   ```

4. **执行 `docker build`**：

   按照上面的步骤之一执行 `docker build` 命令。Docker 将使用指定的 Dockerfile 和构建上下文（在这个例子中是 `/your-project-root/` 或 `/your-project-root/java/`，取决于你选择的命令）来构建镜像。

5. **验证镜像**：

   使用 `docker images` 命令来查看你的镜像是否已成功构建。

请注意，尽管在上述第二种情况中你可以直接进入 `java` 文件夹并执行 `docker build`，但这并不是必需的，而且可能会使你的构建过程与项目结构更加紧密地耦合。通常，建议在项目的根目录中执行构建命令，并使用 `-f` 标志来指定 Dockerfile 的位置，以便更容易地在不同的环境和设置之间迁移你的构建过程。