#!/usr/bin/env sh

NFS_MOUNT_PATH="/mnt/rclone"

while true; do
    NOTIFICATION=$(inotifywait -r -e create "$NFS_MOUNT_PATH")

    DIRECTORY=$(echo "$NOTIFICATION" | awk '{print $1}')

    touch -c "$DIRECTORY"
done
