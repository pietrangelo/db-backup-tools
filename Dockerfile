FROM alpine:3.13

RUN adduser -u 1001 -h /home/backup -D -s /bin/ash  backup \
&& apk --update add --no-cache bash curl busybox-extras vim rsync git mariadb-client mysql-client postgresql-client  openssh-client sshpass \
&& mkdir -p /srv/scripts \
&& mkdir -p /var/backup/mysql \
&& mkdir -p /var/backup/postgresql \
&& mkdir -p /var/backup/mariadb \
&& mkdir -p /home/backup && chown backup /home/backup

COPY scripts/* /srv/scripts/

RUN chmod +x /srv/scripts/* && chown -R 1001:0 /srv/scripts && chmod -R ug+rw /srv/scripts \
&& chown -R 1001:0 /var/backup && chmod -R ug+rw /var/backup

USER backup

WORKDIR /home/backup

CMD ["bash", "-c", "trap : TERM INT; sleep infinity & wait"]