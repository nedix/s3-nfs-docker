# [s3-nfs-container](https://github.com/nedix/s3-nfs-container)

Mount an S3 bucket as an NFS filesystem so it can be used as a Docker or Docker Compose volume.

## Usage

### As a Compose volume

The following Compose manifest will start the s3-nfs service on localhost port `2049`.
It will then make the NFS filesystem available to other services by configuring it as a volume.
The `service_healthy` condition ensures that a connection to the bucket is successfully established before the other services will start using it.
Multiple services can use the same volume.

#### 1. Create the Compose manifest

```shell
wget -q https://raw.githubusercontent.com/nedix/s3-nfs-container/main/docs/examples/compose.yml
```

#### 2. Start the services

```shell
docker compose up -d
```

#### 3. List the S3 bucket contents from inside the example container

```shell
docker compose exec example-container ls /data
```

### As a directory mount

The following example mounts a bucket to a local directory named `s3-nfs`.

#### 1. Start the service

```shell
docker run --pull always --name s3-nfs \
    --cap-add SYS_ADMIN --device /dev/fuse \ # fuse priviliges, these might change in the future \
    -p 127.0.0.1:2049:2049 \
    -e S3_ENDPOINT=foo \
    -e S3_REGION=bar \
    -e S3_BUCKET=baz \
    -e S3_ACCESS_KEY_ID=qux \
    -e S3_SECRET_ACCESS_KEY=quux \
    -d \
    --restart unless-stopped \
    nedix/s3-nfs
```

#### 2. Create a directory to mount the filesystem to

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
