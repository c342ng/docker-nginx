FROM centos:centos7.1.1503

ENV INSTALL_PATH /opt/nginx
ENV DATA_PATH /data/nginx
ENV LOG_PATH /data/logs/nginx
ENV PID_PATH /data/run/nginx.pid
ENV LOCK_PATH /data/run/nginx.lock
ENV USER www-data
ENV GROUP www-data
RUN groupadd -r ${GROUP} && useradd -r -g ${GROUP} ${USER}

RUN yum update --skip-broken && yum install -y ca-certificates curl gcc gcc-c++ make tar \
  && cd /usr/src \
  && curl -Ls http://www.zlib.net/zlib-1.2.10.tar.gz -o zlib-1.2.10.tar.gz \
  && tar -xzvf zlib-1.2.10.tar.gz \
  && curl -Ls ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz -o pcre-8.39.tar.gz \
  && tar -xzvf pcre-8.39.tar.gz \
  && curl -Ls https://www.openssl.org/source/openssl-1.1.0c.tar.gz -o openssl-1.1.0c.tar.gz \
  && tar -xzvf openssl-1.1.0c.tar.gz \
  && curl -Ls http://nginx.org/download/nginx-1.11.8.tar.gz -o nginx-1.11.8.tar.gz \
  && tar -xzvf nginx-1.11.8.tar.gz \
  && cd nginx-1.11.8 \
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
      --with-http_v2_module \
      --with-http_ssl_module \
      --with-http_stub_status_module \
      --with-http_realip_module \
      --with-http_addition_module \
      --with-http_dav_module \
      --with-http_gzip_static_module  \
      --with-pcre-jit \
      --with-pcre=/usr/src/pcre-8.39 \
      --with-zlib=/usr/src/zlib-1.2.10 \
      --with-openssl=/user/src/openssl-1.1.0c \
   && make install \
   && rm /usr/src/*.tar.gz \
   && yum remove -y gcc gcc-c++ make tar \
   && yum clean all 

ENV PATH $PATH:/opt/nginx/sbin/

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /data/logs/nginx/access.log \
	&& ln -sf /dev/stderr /data/logs/nginx/error.log

EXPOSE 80 443

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
