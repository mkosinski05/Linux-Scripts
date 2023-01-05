SRC_DIR=/media/zkmike/RZ/RZV2L
HOST_DIR=/home/zkmike/workspace/yocto/RZV2L
OSS_DIR=/home/zkmike/workspace/yocto/oss_package


docker run -it \
  --name=rzv2ma \
  --volume="${HOST_DIR}:/home/${USER}/yocto" \
  --volume="${SRC_DIR}:/home/${USER}/source" \
  --volume="${OSS_DIR}:/home/${USER}/oss_package" \
  --workdir="/home/${USER}/yocto" \
  rzv2_yocto:1.00
  
docker container prune -f

# ./Scripts/build.sh -b test -w /home/zkmike/yocto/ -s /home/zkmike/source/ -d /home/zkmike/oss_package/
