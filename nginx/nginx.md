```
# 存在nginx 代理问题
user nginx;
worker_processes 1;

error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;


events {
    worker_connections 1024;
}


http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    #tcp_nopush     on;

    keepalive_timeout 65;

    # server {
    #     listen 80;
    #     server_name lerlee.online www.lerlee.online;

    #     # 强制重定向所有 HTTP 请求到 HTTPS
    #     return 301 https://$host$request_uri;
    # }
    # server {
    #     listen 443 ssl;
    #     server_name lerlee.online www.lerlee.online;
    #     ssl_certificate /etc/letsencrypt/live/lerlee.online/fullchain.pem; # 修改为您的证书路径
    #     ssl_certificate_key /etc/letsencrypt/live/lerlee.online/privkey.pem; # 修改为您的私钥路径
    #     location / {
    #         proxy_pass http://127.0.0.1:8090; # 转发到8090端口
    #         proxy_http_version 1.1;
    #         proxy_set_header Upgrade $http_upgrade;
    #         proxy_set_header Connection 'upgrade';
    #         proxy_set_header Host $host;
    #         proxy_cache_bypass $http_upgrade;
    #     }
    # }
    server {
        listen 80;
        #填写绑定证书的域名
        server_name lerlee.online www.lerlee.online;

        # 强制重定向所有 HTTP 请求到 HTTPS
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        #填写绑定证书的域名
        server_name lerlee.online www.lerlee.online;

        #证书文件名称  修改为您的证书路径
        ssl_certificate /root/dockerc/nginx-1.17.8/html/ssl/lerlee.online_nginx/lerlee.online_bundle.crt;
        #私钥文件名称  修改为您的私钥路径
        ssl_certificate_key /root/dockerc/nginx-1.17.8/html/ssl/lerlee.online_nginx/lerlee.online.key;
        ssl_session_timeout 5m;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4; #使用此加密套件。
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; #使用该协议进行配置。
        ssl_prefer_server_ciphers on;


        location / {
            proxy_pass http://halo:8090; # 转发到9090端口
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }

    #gzip  on;
    # server {
    #     listen 80;
    #     server_name lerlee.online;

    #     location / {
    #         proxy_pass http://halo:8090; # 将流量转发到8090端口
    #         proxy_set_header Host $host; # 保持原始主机头部
    #         proxy_set_header X-Real-IP $remote_addr; # 传递真实客户端IP
    #         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; # 转发客户端IP
    #         proxy_set_header X-Forwarded-Proto $scheme; # 转发协议
    #     }
    # }
    # include lerleessl.conf;
    # include /etc/nginx/conf.d/*.conf;
}

```

