事件委托

> ### 什么是事件委托？
>
> **事件委托也称之为事件代理（Event Delegation）。是JavaScript中常用绑定事件的常用技巧。顾名思义，“事件代理”即是把原本需要绑定在子元素的响应事件委托给父元素，让父元素担当事件监听的职务。事件代理的原理是DOM元素的事件冒泡。**

[[JavaScript篇\] 一文彻底弄懂事件委托（事件代理）_事件代理和事件委托的区别-CSDN博客](https://blog.csdn.net/Wps1919/article/details/124680326)

**答：** 事件委托的原理是，通过给父元素绑定事件，然后通过事件对象的 target 属性来判断点击的是不是子元素，从而实现对子元素的监听。本质是dom树结构，事件冒泡。



//修复数据表删除但minio数据依旧存储



```java
        // 第一个删除任务
        executorService.submit(() -> {
            if (url!= null &&!url.isEmpty()) {
                String str1 = SubstringUtil.extractPointcloud(url, applicationName);
                boolean removeRes = minioService.removeObjectss(bucketName, str1);
            }
        });

        // 第二个删除任务
        executorService.submit(() -> {
            if (url2!= null &&!url2.isEmpty()) {
                String str2 = SubstringUtil.extractPointcloud(url2, applicationName);
                boolean removeRes2 = minioService.removeObjectss(bucketName, str2);
            }
        });

        // 关闭线程池，等待所有任务完成
        executorService.shutdown();
```

```
    location /resource/ {
  		alias  /data/efuav/reseeding/resource/;
  		expires      30d;
  		error_log /dev/null;
      access_log /dev/null;
  		# allow all;
  		# autoindex on;# 开启预览功能
  		# root /usr/share/resource;
  		# proxy_pass  https://efuavserverhost:8081/efapi/uavsystem/resource/;
  	}
```

```
docker run -d -p 9000:9000 -p 9090:9090 --name minio2 -e "MINIO_ACCESS_KEY=minioadmin" -e "MINIO_SECRET_KEY=minioadmin" minio/minio server /data --console-address ":9090" 
```

