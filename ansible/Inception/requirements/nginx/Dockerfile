FROM debian:bookworm

RUN apt update && apt install -y nginx  

COPY	conf/nginx.conf /etc/nginx/sites-available/default
RUN     chmod 777 /etc/nginx/sites-available/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]