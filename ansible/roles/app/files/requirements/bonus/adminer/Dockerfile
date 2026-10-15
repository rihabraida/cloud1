FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php php-mysql curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www \
 && curl -L -o /var/www/index.php https://www.adminer.org/latest.php

EXPOSE 8083

CMD ["php", "-S", "0.0.0.0:8083", "-t", "/var/www"]