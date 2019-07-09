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
  cron  \
  procps \
  nginx  && rm -rf /var/lib/apt/lists/* 


WORKDIR /usr/share/nginx/html
#CMD cd /usr/share/nginx/html &&  nginx -g 'daemon off;'
#CMD ["cron","-f"]
CMD /app/start.sh
