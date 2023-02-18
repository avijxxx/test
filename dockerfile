FROM irinesistiana/mosdns:v4.5.3
LABEL maintainer="None"
COPY entrypoint.sh /
RUN wget https://mirror.apad.pro/dns/easymosdns.tar.gz 
RUN tar tar -xzf easymosdns.tar.gz  -C /etc/mosdns --strip-components=1 \
	&&  chmod +x entrypoint.sh \
	&&  apk add --no-cache ca-certificates \
	&&  apk add --no-cache curl \
	&&  echo '15 7 * * *  0 5 * * * /etc/mosdns/rules/update-cdn'>/var/spool/cron/crontabs/root \
	&&  chmod 600 /var/spool/cron/crontabs/root \
	&&  chmod +x /usr/bin/mosdns \
	&&  ln -sf /dev/stdout /etc/mosdns/log.txt \
	&&  apk -U add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&&  echo "Asia/Shanghai" > /etc/timezone \
	&&  apk del tzdata



VOLUME /etc/mosdns
EXPOSE 53/udp 53/tcp
#CMD /usr/bin/mosdns start --dir /etc/mosdns
CMD sh entrypoint.sh
#ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
