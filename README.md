# s3-nfs-docker

This Docker image mounts an S3 bucket as a remote file system using NFS and [rclone](https://github.com/rclone/rclone).

## Usage

### Standalone

**Start the NFS server on port 2049**

```shell
docker run --rm -it --cap-add SYS_ADMIN --device /dev/fuse -p 2049:2049 --name s3-nfs \
    -e S3_NFS_ENDPOINT=foo \
    -e S3_NFS_BUCKET=bar \
    -e S3_NFS_ACCESS_KEY_ID=baz \
    -e S3_NFS_SECRET_ACCESS_KEY=qux \
    ghcr.io/nedix/s3-nfs-docker
```

**Mount on rclone directory (outside container)**

```shell
mkdir rclone \
&& mount -v -o vers=4 127.0.0.1:/ ./rclone
```

### As a Docker Compose volume provisioner

```yaml
version: "3.8"

services:
  s3-nfs:
    image: ghcr.io/nedix/s3-nfs-docker
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse:/dev/fuse:rwm
    environment:
      S3_NFS_ENDPOINT: foo
      S3_NFS_BUCKET: bar
      S3_NFS_ACCESS_KEY_ID: baz
      S3_NFS_SECRET_ACCESS_KEY: qux
    ports:
      - '2049:2049'

  your-service:
    image: foo
    depends_on:
      s3-nfs:
        condition: service_healthy
    volumes:
      - 's3-nfs:/mnt/nfs'

volumes:
  s3-nfs:
    driver_opts:
      type: 'nfs'
      o: 'vers=4,addr=127.0.0.1,port=2049,rw'
      device: ':/'
```

## Development

1. Clone this repo
2. Copy the .env.example file to .env and configure
3. Execute the `make setup` command
4. Execute the `make up` command
