FROM poppen/radikorec
MAINTAINER MATSUI Shinsuke <poppen.jp@gmail.com>

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ADD crontab /etc/cron.d/run-radikorec
RUN chmod 0644 /etc/cron.d/run-radikorec

ADD rec_radiru.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/rec_radiru.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
