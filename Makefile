setup:
	@docker build . -t rclone-nfs

up: detach =
up:
	@docker run --rm $(if $(detach),-d,) --cap-add SYS_ADMIN --device /dev/fuse --env-file=.env -p 2049:2049 --name rclone-nfs \
		rclone-nfs

run:
	@docker run --rm -it --cap-add SYS_ADMIN --device /dev/fuse --env-file=.env -p 2049:2049 --name rclone-nfs \
		--entrypoint /bin/sh \
		rclone-nfs
