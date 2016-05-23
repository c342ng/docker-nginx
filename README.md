# docker-nginx
docker run -d --link=php-server:fpm-server -p 80:80 -p 443:443 -v /home/cc/work/docker-nginx/conf.d/:/etc/nginx/conf.d/:ro -v /opt/webroot:/usr/share/nginx/html/:ro 7d89683db262
