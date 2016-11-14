FROM nginx:1.11.5

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list.d/jessie-backports.list && apt-get update
RUN apt-get install -y certbot -t jessie-backports
