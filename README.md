# rclone-nfs-docker

This Docker image will deploy an NFS server, which uses [rclone](https://github.com/rclone/rclone) to enable remote
mounting of an S3 bucket.

## Usage

**Start NFS server on port 2049**

```shell
docker run --rm -it --cap-add SYS_ADMIN --device /dev/fuse -p 2049:2049 --name rclone-nfs \
    -e S3_ENDPOINT=foo \
    -e S3_BUCKET=bar \
    -e S3_ACCESS_KEY_ID=baz \
    -e S3_SECRET_ACCESS_KEY=qux \
     ghcr.io/nedix/rclone-nfs-docker
```

**Mount on rclone directory (outside container)**

```shell
mkdir rclone \
&& mount -v -o vers=4 127.0.0.1:/ ./rclone
```

## Development

1. Clone this repo
2. Copy the .env.example file to .env and configure
3. Execute the `make setup` command
4. Execute the `make up` command
