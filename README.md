# docker-nginx

sudo docker run -d --link=fpm-server:fpm-server -p 80:80 -p 443:443 -v /home/cc/work/docker-nginx/conf.d/:/etc/nginx/conf.d/:ro -v /home/cc/webroot:/tmp/:ro xxxxxx
