#!/usr/bin/env sh

MOUNT_PATH="/mnt/rclone"

while true; do
    NOTIFICATION=$(inotifywait -r -e create "$MOUNT_PATH")

    DIRECTORY=$(echo "$NOTIFICATION" | awk '{print $1}')

    touch -c "$DIRECTORY"
done
