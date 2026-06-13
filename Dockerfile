FROM nginx:alpine

# 复制所有静态文件到 nginx 默认目录
COPY . /usr/share/nginx/html

# 使用默认的 nginx 配置即可，暴露 80 端口
EXPOSE 80
