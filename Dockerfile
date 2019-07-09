FROM debian:latest
COPY . /app
ADD crontab /etc/cron.d/cron-scan
RUN chmod 0644 /etc/cron.d/cron-scan && touch /var/log/cron.log
RUN apt-get update && apt-get install -y \
  wget \
  curl \
  gnuplot \
  bash    \
  cron  \
  nginx

WORKDIR /usr/share/nginx/html
CMD cd /usr/share/nginx/html &&  nginx -g 'daemon off;' 	
