FROM nginx:1.11.5

RUN  apt-get update && apt-get install -y vim wget curl
RUN wget https://dl.eff.org/certbot-auto && chmod a+x certbot-auto && ./certbot-auto
