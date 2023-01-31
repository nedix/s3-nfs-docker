#!/usr/bin/env sh

mkdir -p \
    /etc/rclone \
    /mnt/rclone \
    /run/openrc

cat << EOF > /etc/rclone/.env
RCLONE_S3_BUCKET="$RCLONE_S3_BUCKET"
EOF

cat << EOF > /etc/rclone/rclone.conf
[default]
type = s3
provider = Other
access_key_id = $RCLONE_S3_ACCESS_KEY_ID
secret_access_key = $RCLONE_S3_SECRET_ACCESS_KEY
endpoint = $RCLONE_S3_ENDPOINT
EOF

rc-update add nfs
rc-update add rclone
rc-update add timestamp_updater

touch /run/openrc/softlevel

sed -i 's/^tty/#&/' /etc/inittab

exec /sbin/init
