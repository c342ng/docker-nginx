# docker-nginx
docker run -d --name=nginx-server --link=fpm-server:fpm-server -p 80:80 -p 443:443 -v /home/cc/work/docker-nginx/conf.d/:/etc/nginx/conf.d/:ro -v /opt/webroot:/usr/share/nginx/html/:ro image_id
