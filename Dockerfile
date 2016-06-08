FROM nginx:1.10.0

RUN  apt-get update && apt-get install -y vim wget curl
