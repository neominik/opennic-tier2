FROM alpine

WORKDIR /etc/bind/

COPY entrypoint.sh ./

RUN apk --update add bind bash && \
  wget http://161.97.219.84/opennic.oss/files/scripts/srvzone && \
  wget http://161.97.219.84/opennic.oss/files/scripts/srvzone.conf && \
  chmod 700 srvzone && \
  mkdir -p opennic/master && mkdir opennic/slave && \
  chown -R named:named . && \
  ./srvzone && \
  echo "nameserver 127.0.0.1" > /etc/resolv.conf && \
  echo 'include "/etc/bind/named.conf.opennic";' > named.conf && \
  echo "39 * * * * /etc/bind/srvzone >> /var/log/cron.log 2>&1" >> /etc/crontabs/root

EXPOSE 53

ENTRYPOINT ["./entrypoint.sh", "-g", "-u", "named", "-c", "/etc/bind/named.conf"]

HEALTHCHECK --timeout=10s --interval=10s CMD /bin/bash -c "dig @127.0.0.1 NS opennic.glue. >/dev/null"
