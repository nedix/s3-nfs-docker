ARG RCLONE_VERSION=1.61.1

FROM rclone/rclone:$RCLONE_VERSION as rclone

FROM --platform=$BUILDPLATFORM alpine:3.17

COPY --from=rclone /usr/local/bin/rclone /usr/bin/rclone

RUN apk add \
        fuse \
        nfs-utils \
        nfs-utils-doc \
        nfs-utils-openrc \
        openrc \
        psmisc

ADD rootfs /

RUN chmod +x /entrypoint.sh /etc/init.d/rclone

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2049/tcp

VOLUME /var/rclone

HEALTHCHECK CMD mountpoint -q /mnt/rclone || exit 1
