FROM nginx:1.11.5

RUN wget https://dl.eff.org/certbot-auto && chmod a+x certbot-auto && ./certbot-auto
