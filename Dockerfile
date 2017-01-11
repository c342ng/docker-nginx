FROM centos:centos7.1.1503

ENV INSTALL_PATH /opt/nginx
ENV DATA_PATH /data/nginx
ENV LOG_PATH /data/logs/nginx
ENV PID_PATH /data/run/nginx.pid
ENV LOCK_PATH /data/run/nginx.lock
ENV USER www-data
ENV GROUP www-data

RUN yum update --skip-broken && yum install -y ca-certificates curl gcc make tar \
  && yum install -y pcre-devel zlib-devel \
  && cd /usr/src && curl -Ls http://nginx.org/download/nginx-1.11.8.tar.gz -o nginx-1.11.8.tar.gz \
  && tar -xzvf nginx-1.11.8.tar.gz && cd nginx-1.11.8 \
  && ./configure --user=www-data --group=www-data \
      --prefix=${INSTALL_PATH} \
      --http-log-path=${LOG_PATH} \
      --error-log-path=${LOG_PATH} \
      --http-client-body-temp-path="${DATA_PATH}/client-body-temp" \
      --http-proxy-temp-path="${DATA_PATH}/proxy-temp" \
      --http-fastcgi-temp-path="${DATA_PATH}/proxy-temp" \
      --http-uwsgi-temp-path="${DATA_PATH}/uwsgi-temp" \
      --http-scgi-temp-path="${DATA_PATH}/scgi-temp" \
      --http-fastcgi-temp-path="${DATA_PATH}/proxy-temp" \
   && make install
      
