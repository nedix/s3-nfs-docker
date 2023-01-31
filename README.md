# s3-nfs-docker

This Docker image mounts an S3 bucket as a remote file system using NFS and [rclone](https://github.com/rclone/rclone).

## Usage

### Standalone

**Start the NFS server on port 2049**

```shell
docker run --rm -it --cap-add SYS_ADMIN --device /dev/fuse -p 2049:2049 --name s3-nfs \
    -e RCLONE_S3_ENDPOINT=foo \
    -e RCLONE_S3_BUCKET=bar \
    -e RCLONE_S3_ACCESS_KEY_ID=baz \
    -e RCLONE_S3_SECRET_ACCESS_KEY=qux \
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
  rclone:
    image: ghcr.io/nedix/s3-nfs-docker
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse:/dev/fuse:rwm
    environment:
      RCLONE_S3_ENDPOINT: foo
      RCLONE_S3_BUCKET: bar
      RCLONE_S3_ACCESS_KEY_ID: baz
      RCLONE_S3_SECRET_ACCESS_KEY: qux
    ports:
      - '2049:2049'

  your-service:
    image: foo
    depends_on:
      rclone:
        condition: service_healthy
    volumes:
      - 'nfs:/mnt/nfs'

volumes:
  nfs:
    driver_opts:
      type: 'nfs'
      o: 'addr=127.0.0.1,vers=4,rw'
      device: ':/'
```

## Development

1. Clone this repo
2. Copy the .env.example file to .env and configure
3. Execute the `make setup` command
4. Execute the `make up` command
