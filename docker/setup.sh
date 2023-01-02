
docker build --no-cache --rm \
--build-arg "host_uid=$(id -u)" \
--build-arg "ver_bsp=v102" \
--build-arg "USERNAME=$(whoami)" \
--build-arg "host_gid=$(id -g)" \
--file Dockerfile.rzg_ubuntu-20.04 \
--tag "rzv2_yocto:1.00" .

