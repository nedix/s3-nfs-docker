setup:
	@docker build . -t s3-nfs

up: port = 2049
up:
	@docker run --rm --name s3-nfs \
        --cap-add SYS_ADMIN \
        --device /dev/fuse \
        -v /sys/fs/cgroup/s3-nfs:/sys/fs/cgroup:rw \
        --env-file .env \
        -p $(port):2049 \
        -d \
        s3-nfs

down:
	-@docker stop s3-nfs

shell:
	@docker exec -it s3-nfs /bin/sh
