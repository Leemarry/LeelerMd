## 1. minio 

开发机 : 容器名minio

```
不用动  --restart=always  --privileged=true

docker run -d -p 9002:9000 -p 9092:9090 --name pointcloud-minio -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9090" 

docker cp pointcloud-minio:/data  F:\docker\dockerc\pointcloud-minio
docker cp pointcloud-minio:/root/.minio  F:\docker\dockerc\pointcloud-minio\config

docker run -d -p 9002:9000 -p 9092:9090 --name pointcloud-minio -v F:\docker\dockerc\pointcloud-minio\data:/data  -v F:\docker\dockerc\pointcloud-minio\config:/root/.minio -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9090" 
```

部署机 : 容器名minio

```

```

## 2.redis

开发机 : 容器名minio

```

```

部署机 : 容器名minio

```
miniosource/efuav-cloud/pointcloud/gs-cloud_B004_B009136/gs-cloud_B004_B009/lidars/terra_pnts/tileset.json
```



## 3.emqx

开发机 : 容器名cloudemqx

```
docker run -d --name cloudemqx  --restart=always  --privileged=true -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083  emqx/emqx:latest
```

部署机 : 容器名cloudemqx

```
docker run -d --name cloudemqx  --restart=always  --privileged=true -p 1883:1883 -p 8883:8883 -p 8083:8083 -p 8084:8084 -p 8081:8081 -p 18083:18083  emqx/emqx:latest
```

## 4.mysql

开发机 : 容器名mysql

```

```

部署机 : 容器名mysql

```

```

## 5.java-jar

开发机 : 容器名minio

```

```

部署机 : 容器名minio

```

```

## 6.nginx

开发机 : 容器名minio

```

```

部署机 : 容器名nginx1

```

```



![image-20241014145041149](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241014145041149.png)



![image-20241014145109000](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241014145109000.png)



![image-20241014145246652](https://image-1302217890.cos.ap-beijing.myqcloud.com/mdimages/image-20241014145246652.png)
