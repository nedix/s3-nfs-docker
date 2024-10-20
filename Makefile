setup:
	@docker build --progress=plain -f Containerfile -t s3-nfs .

up: PORT = 2049
up:
	@docker run --rm --name s3-nfs \
        --cap-add SYS_ADMIN \
        --device /dev/fuse \
        -v /sys/fs/cgroup/s3-nfs:/sys/fs/cgroup:rw \
        --env-file .env \
        -p $(PORT):2049 \
        -d \
        s3-nfs

down:
	@-docker rm -f s3-nfs

shell:
	@docker exec -it s3-nfs /bin/sh
