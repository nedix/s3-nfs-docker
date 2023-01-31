setup:
	@docker build . -t s3-nfs

up: detach =
up:
	@docker run --rm $(if $(detach),-d,) --cap-add SYS_ADMIN --device /dev/fuse --env-file=.env -p 2049:2049 --name s3-nfs \
		s3-nfs

run:
	@docker run --rm -it --cap-add SYS_ADMIN --device /dev/fuse --env-file=.env -p 2049:2049 --name s3-nfs \
		--entrypoint /bin/sh \
		s3-nfs
