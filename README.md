# docker-nginx
docker run -d --name=nginx-server --link=fpm-server:fpm-server -p 80:80 -p 443:443 -v "${pwd}/conf.d/:/etc/nginx/conf.d/:ro -v /opt/webroot:/usr/share/nginx/html/:ro c3t3m3/docker-nginx
