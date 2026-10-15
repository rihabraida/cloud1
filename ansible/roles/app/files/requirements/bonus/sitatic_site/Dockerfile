FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/conf.d/static.conf
RUN chmod 644 /etc/nginx/conf.d/static.conf

COPY tools/index.html /var/www/html/index.html
RUN chmod 644 /var/www/html/index.html

CMD ["nginx", "-g", "daemon off;"]