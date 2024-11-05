在root 创建halomysql 放入 docker-compose.yaml  mysql 密码为 o#DwN&JSa56 

```
version: "3"

services:
  halo:
    image: halohub/halo:2.6.0
    container_name: halo
    restart: on-failure:3
    depends_on:
      halodb:
        condition: service_healthy
    networks:
      halo_network:
    volumes:
      - ./halo2/:/root/.halo2
    ports:
      - "8090:8090"
    command:
      - --spring.r2dbc.url=r2dbc:pool:mysql://halodb:3306/halo
      - --spring.r2dbc.username=root
      # MySQL 的密码，请保证与下方 MYSQL_ROOT_PASSWORD 的变量值一致。
      - --spring.r2dbc.password=o#DwN&JSa56
      - --spring.sql.init.platform=mysql
      # 外部访问地址，请根据实际需要修改lerlee.online、www.lerlee.online
      - --halo.external-url=https://lerlee.online
      # 初始化的超级管理员用户名
      - --halo.security.initializer.superadminusername=admin  
      # 初始化的超级管理员密码
      - --halo.security.initializer.superadminpassword=lerlee
  halodb:
    image: mysql:8.0.31
    container_name: halodb
    restart: on-failure:3
    networks:
      halo_network:
    command: 
      - --default-authentication-plugin=mysql_native_password
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_general_ci
      - --explicit_defaults_for_timestamp=true
    volumes:
      - ./mysql:/var/lib/mysql
      - ./mysqlBackup:/data/mysqlBackup
    ports:
      -  "3306:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "--silent"]
      interval: 3s
      retries: 5
      start_period: 30s
    environment:
      # 请修改此密码，并对应修改上方 Halo 服务的 SPRING_R2DBC_PASSWORD 变量值
      - MYSQL_ROOT_PASSWORD=o#DwN&JSa56
      - MYSQL_DATABASE=halo

networks:
  halo_network:

```

升级:2.18  修改 docker-compose.yaml   

```
version: "3"

services:
  halo:
    image: halohub/halo:2.18
    container_name: halo
    restart: on-failure:3
    depends_on:
      halodb:
        condition: service_healthy
    networks:
      halo_network:
    volumes:
      - ./halo2/:/root/.halo2
    ports:
      - "8090:8090"
    command:
      - --spring.r2dbc.url=r2dbc:pool:mysql://halodb:3306/halo
      - --spring.r2dbc.username=root
      # MySQL 的密码，请保证与下方 MYSQL_ROOT_PASSWORD 的变量值一致。
      - --spring.r2dbc.password=o#DwN&JSa56
      - --spring.sql.init.platform=mysql
      # 外部访问地址，请根据实际需要修改lerlee.online、www.lerlee.online
      - --halo.external-url=https://lerlee.online
      # 初始化的超级管理员用户名
      - --halo.security.initializer.superadminusername=admin  
      # 初始化的超级管理员密码
      - --halo.security.initializer.superadminpassword=lerlee
  halodb:
    image: mysql:8.0.31
    container_name: halodb
    restart: on-failure:3
    networks:
      halo_network:
    command: 
      - --default-authentication-plugin=mysql_native_password
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_general_ci
      - --explicit_defaults_for_timestamp=true
    volumes:
      - ./mysql:/var/lib/mysql
      - ./mysqlBackup:/data/mysqlBackup
    ports:
      -  "3306:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "--silent"]
      interval: 3s
      retries: 5
      start_period: 30s
    environment:
      # 请修改此密码，并对应修改上方 Halo 服务的 SPRING_R2DBC_PASSWORD 变量值
      - MYSQL_ROOT_PASSWORD=o#DwN&JSa56
      - MYSQL_DATABASE=halo

networks:
  halo_network:

```

```
docker-compose pull 
docker-compose up -d
# https://blog.laoda.de/archives/docker-compose-install-halo-version-2

docker-compose down
cp -r /root/dockersql  /root/halomysql.archive  # 万事先备份，以防万一
docker-compose pull

docker-compose up -d    # 请不要使用 docker-compose stop 来停止容器，因为这么做需要额外的时间等待容器停止；docker-compose up -d 直接升级容器时会自动停止并立刻重建新的容器，完全没有必要浪费那些时间。

docker image prune  # prune 命令用来删除不再使用的 docker 对象。删除所有未被 tag 标记和未被容器使用的镜像
```

networks:
  my_network:
