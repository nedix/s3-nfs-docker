# [s3-nfs-container](https://github.com/nedix/s3-nfs-container)

Mount an S3 bucket as an NFS filesystem to use it as a Docker or Docker Compose volume.

## Usage

#### Start the NFS server

This example command starts an NFS server on localhost port `2049`.

```shell
docker run --pull always --name s3-nfs \
    --cap-add SYS_ADMIN --device /dev/fuse \ # fuse priviliges, these might not be necessary in the future
    -v /sys/fs/cgroup/s3-nfs:/sys/fs/cgroup:rw \ # support v2 cgroups
    -p 2049:2049 \
    -e S3_NFS_ENDPOINT=foo \
    -e S3_NFS_REGION=bar \
    -e S3_NFS_BUCKET=baz \
    -e S3_NFS_ACCESS_KEY_ID=qux \
    -e S3_NFS_SECRET_ACCESS_KEY=quux \
    -d \
    --restart unless-stopped \
    nedix/s3-nfs
```

#### (Option 1.) Mount on a path outside the container

This example command mounts an NFS filesystem on a directory named `s3-nfs`.

```shell
mkdir s3-nfs \
&& mount -v -o vers=4 -o port=2049 127.0.0.1:/ ./s3-nfs
```

#### (Option 2.) Use as a Compose volume

The example Compose manifest will start the s3-nfs service on localhost port `2049`.
It will then make the NFS filesystem available to other services by configuring it as a volume.
The `service_healthy` condition ensures that a connection to an S3 bucket has been established before the other service can start using it.
Multiple services can use the same volume.

```shell
wget -q https://raw.githubusercontent.com/nedix/s3-nfs-container/main/docs/examples/compose.yml
docker compose up -d
docker compose exec example-service ls /data
```

<hr>

## Attribution

Powered by [rclone].

[rclone]: https://github.com/rclone/rclone
