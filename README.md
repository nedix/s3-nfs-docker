# s3-nfs-docker

Mount an S3 bucket as an NFS filesystem, which can be used as a Docker or Docker Compose volume.

## Usage

#### Start the NFS server

This example command starts an NFS server on localhost port `2049`.

```shell
docker run --pull always --name s3-nfs \
    --cap-add SYS_ADMIN --device /dev/fuse \ # fuse priviliges, these might not be necessary in the future
    -p 2049:2049 \
    -e S3_NFS_ENDPOINT=foo \
    -e S3_NFS_REGION=bar \
    -e S3_NFS_BUCKET=baz \
    -e S3_NFS_ACCESS_KEY_ID=qux \
    -e S3_NFS_SECRET_ACCESS_KEY=quux \
    -d \
    --restart unless-stopped \
    ghcr.io/nedix/s3-nfs-docker
```

#### (Optional) Mount on a path outside the container

This example command mounts an NFS filesystem on a directory named `s3-nfs`.

```shell
mkdir s3-nfs \
&& mount -v -o vers=4 -o port=2049 127.0.0.1:/ ./s3-nfs
```

#### (Optional) Use as a Docker Compose volume

This example Docker Compose manifest will start an s3-nfs service on localhost port `2049`.
It will then make the NFS filesystem available to other services by making it available as a volume.
The `service_healthy` condition ensures that a connection to the S3 bucket was established before the other service can start using it.
Multiple services can use the same volume.

*docker-compose.yml*

```yaml
services:
  s3-nfs:
    image: ghcr.io/nedix/s3-nfs-docker
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse:/dev/fuse:rwm
    environment:
      S3_NFS_ENDPOINT: foo
      S3_NFS_REGION: bar
      S3_NFS_BUCKET: baz
      S3_NFS_ACCESS_KEY_ID: qux
      S3_NFS_SECRET_ACCESS_KEY: quux
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

<hr>

## Attribution

Powered by [rclone].

[rclone]: https://github.com/rclone/rclone
