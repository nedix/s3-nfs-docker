# [s3-nfs-container](https://github.com/nedix/s3-nfs-container)

Mount an S3 bucket as an NFS filesystem to use it as a Docker or Docker Compose volume.

## Usage

### As a Compose volume

The example Compose manifest will start the s3-nfs service on localhost port `2049`.
It will then make the NFS filesystem available to other services by configuring it as a volume.
The `service_healthy` condition ensures that a connection to an S3 bucket has been established before the other service can start using it.
Multiple services can use the same volume.

#### 1. Create the Compose manifest

```shell
wget -q https://raw.githubusercontent.com/nedix/s3-nfs-container/main/docs/examples/compose.yml
```

#### 2. Start the services

```shell
docker compose up -d
```

#### 3. Browse the S3 bucket from inside the example service

```shell
docker compose exec example-service ls /data
```

### As a directory mount

This example mounts the S3 bucket to a local directory named `s3-nfs`.

#### 1. Start the NFS server

```shell
docker run --pull always --name s3-nfs \
    --cap-add SYS_ADMIN --device /dev/fuse \ # fuse priviliges, these might not be necessary in the future \
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

#### 2. Create a directory for the mount

```shell
mkdir s3-nfs
```

#### 3. Mount the filesystem

```shell
mount -v -o vers=4 -o port=2049 127.0.0.1:/ ./s3-nfs
```

<hr>

## Attribution

Powered by [rclone].

[rclone]: https://github.com/rclone/rclone
