```powershell
server {
	listen 443 ssl;
	#填写绑定证书的域名
	server_name lerlee.online www.lerlee.online;
	#证书文件名称
	ssl_certificate /root/dockerc/nginx-1.17.8/ssl/lerlee.online_nginx/lerlee.online_bundle.crt;
	#私钥文件名称
	ssl_certificate_key /root/dockerc/nginx-1.17.8/ssl/lerlee.online_nginx/lerlee.online.key;

    location / {  
        proxy_pass http://halo:8090;  # 转发到8090端口  
        proxy_http_version 1.1;  
        proxy_set_header Upgrade $http_upgrade;  
        proxy_set_header Connection 'upgrade';  
        proxy_set_header Host $host;  
        proxy_cache_bypass $http_upgrade;  
    }  

}

```

