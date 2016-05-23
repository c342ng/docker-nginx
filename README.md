# docker-nginx
sudo docker run -t --link=php-server:fpm-server -p 80:80 -p 443:443 -v /home/cc/work/docker-nginx/conf.d/:/etc/nginx/conf.d/:ro -v /home/cc/webroot:/usr/share/nginx/html/:ro 7d89683db262
