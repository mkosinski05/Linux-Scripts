docker build --no-cache \
  --build-arg "host_uid=$(id -u)" \
  --build-arg "host_gid=$(id -g)" \
  --build-arg "USERNAME=$USER" \
  --build-arg "TZ_VALUE=$(cat /etc/timezone)" \
  -t rzv_ubuntu:20.04 \
  --file Dockerfile.rzv_ubuntu-20.04  .
