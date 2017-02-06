FROM centos:centos7.1.1503

ENV OPT_PATH /opt/nginx
ENV CONF_PATH /opt/nginx/conf
ENV DATA_PATH /data/nginx
ENV LOG_PATH /data/logs/nginx

ENV PID_PATH /data/run/

ENV USER nginx
ENV GROUP nginx

RUN groupadd -r ${GROUP} && useradd -r -g ${GROUP} ${USER}
RUN mkdir -p ${OPT_PATH} ${CONF_PATH} ${DATA_PATH} ${LOG_PATH} ${PID_PATH}\
  && chown "${GROUP}:${USER}" ${OPT_PATH} ${CONF_PATH} ${DATA_PATH} ${LOG_PATH} ${PID_PATH}
  
ENV NGINX_VERSION 1.11.8
ENV ZLIB_VERSION 1.2.10
ENV PCRE_VERSION 8.39
ENV OPENSSL_VERSION 1.1.0c

RUN rpm --rebuilddb && yum swap -y fakesystemd systemd && yum update -y && yum install -y systemd-devel \
    && yum install -y ca-certificates curl tar perl gcc gcc-c++ make \
    && cd /usr/src \
    && curl -Ls http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz -o zlib-${ZLIB_VERSION}.tar.gz \
    && tar -xzvf zlib-${ZLIB_VERSION}.tar.gz \
    && curl -Ls ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz -o pcre-${PCRE_VERSION}.tar.gz \
    && tar -xzvf pcre-${PCRE_VERSION}.tar.gz \
    && curl -Ls https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -o openssl-${OPENSSL_VERSION}.tar.gz \
    && tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz \
    && curl -Ls http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx-${NGINX_VERSION}.tar.gz \
    && tar -xzvf nginx-${NGINX_VERSION}.tar.gz \
    && cd /usr/src/nginx-${NGINX_VERSION} \
    && ./configure \
        --prefix=${OPT_PATH} \
        --sbin-path=${OPT_PATH}/sbin/nginx \
        --modules-path=${OPT_PATH}/modules \
        --conf-path=${CONF_PATH}/nginx.conf \
        --error-log-path=${LOG_PATH}/error.log \
        --http-log-path=${LOG_PATH}/access.log \
        --pid-path=${PID_PATH}/nginx.pid \
        --lock-path=${PID_PATH}/nginx.lock \
        --http-client-body-temp-path=${DATA_PATH}/client_temp \
        --http-proxy-temp-path=${DATA_PATH}/proxy_temp \
        --http-fastcgi-temp-path=${DATA_PATH}/fastcgi_temp \
        --http-uwsgi-temp-path=${DATA_PATH}/uwsgi_temp \
        --http-scgi-temp-path=${DATA_PATH}/scgi_temp \
        --user=${USER} \
        --group=${GROUP} \
        --with-compat \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
        --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed' \
        --with-pcre-jit \
        --with-pcre=/usr/src/pcre-${PCRE_VERSION} \
        --with-zlib=/usr/src/zlib-${ZLIB_VERSION} \
        --with-openssl=/usr/src/openssl-${OPENSSL_VERSION} \
   && make install && make clean \
   && rm -rf /usr/src/pcre* /user/src/openssl* /usr/src/zlib* \
   && yum remove -y perl gcc gcc-c++ make \
   && yum clean all 

ENV PATH $PATH:${OPT_PATH}/sbin/

RUN ln -sf /etc/nginx/ ${CONF_PATH}

# forward request and error logs to docker log collector
RUN touch ${LOG_PATH}/access.log \
  && touch ${LOG_PATH}/error.log \
  && ln -sf /dev/stdout ${LOG_PATH}/access.log \
  && ln -sf /dev/stderr ${LOG_PATH}/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
