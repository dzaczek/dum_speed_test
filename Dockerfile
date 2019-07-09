FROM debian:latest
COPY . /app
ADD crontab /etc/cron.d/cron-scan
#VOLUME /usr/share/nginx/html
EXPOSE 80
RUN chmod 0644 /etc/cron.d/cron-scan && touch /var/log/cron.log ; chmod 0644 /app/start.sh 
RUN apt-get update && apt-get install -y \
  wget \
  curl \
  gnuplot \
  bash    \
  procps \
  nginx && echo "<img src=speedtest.png>" > /var/www/html/index.html  && rm -rf /var/lib/apt/lists/* 


WORKDIR /var/www/html/
#CMD cd /usr/share/nginx/html &&  nginx -g 'daemon off;'
#CMD ["cron","-f"]
CMD /bin/bash /app/start.sh
