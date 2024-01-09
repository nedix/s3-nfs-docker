ARG ALPINE_VERSION=3.19
ARG RCLONE_VERSION=1.65.1

FROM rclone/rclone:${RCLONE_VERSION} as rclone

FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION}

COPY --from=rclone /usr/local/bin/rclone /usr/bin/rclone

RUN apk add \
        fuse3 \
        inotify-tools \
        nfs-utils \
        nfs-utils-openrc \
        openrc \
        psmisc

ADD rootfs /

RUN chmod +x \
        /entrypoint.sh \
        /usr/local/bin/timestamp_updater.sh \
        /etc/init.d/rclone \
        /etc/init.d/timestamp_updater

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2049/tcp

VOLUME /var/rclone

HEALTHCHECK CMD mountpoint -q /mnt/rclone || exit 1
