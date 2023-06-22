SRC_DIR=/media/zkmike/RZ/RZG2L
HOST_DIR=/home/zkmike/workspace/yocto/RZG2L
OSS_DIR=/home/zkmike/workspace/yocto/RZG2L/oss_package

docker container prune -f

docker run -it \
  --name=rzg2l \
  --volume="${HOST_DIR}:/home/${USER}/yocto" \
  --volume="${SRC_DIR}:/home/${USER}/source" \
  --volume="${OSS_DIR}:/home/${USER}/oss_package" \
  --workdir="/home/${USER}/yocto" \
  rzg2_yocto:1.00
  
docker container prune -f
