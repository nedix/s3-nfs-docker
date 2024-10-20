#!/usr/bin/env sh

: ${DIR_CACHE_TIME}

exec watch -tn "$DIR_CACHE_TIME" /usr/bin/rclone rc \
    vfs/refresh \
    recursive=true \
    > /dev/null
