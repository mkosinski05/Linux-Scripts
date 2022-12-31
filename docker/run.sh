SRC_DIR=/media/zkmike/RZ/RZV2MA
HOST_DIR=/home/zkmike/workspace/yocto/RZV2MA
OSS_DIR=/home/zkmike/workspace/yocto/oss_package

mkdir rzv2ma


pushd ${SRC_DIR}
LinuxBSP=`find ${SRC_DIR} -name r01an6514ej0100-* -printf "%f\n"`
Codec=`find ${SRC_DIR} -name RTK0EF0131F02000SJ-* -printf "%f\n"`
OPENCV=`find ${SRC_DIR} -name r11an0650ej0100-* -printf "%f\n"`
DRP=`find ${SRC_DIR} -name r11an0592ej0720-* -printf "%f\n"`
popd

cp $SRC_DIR/${LinuxBSP} .
cp $SRC_DIR/${Codec} .
cp $SRC_DIR/${OPENCV} .
cp $SRC_DIR/${DRP} .

docker run -it \
  --name=rzv2ma \
  --volume="${HOST_DIR}:/home/${USER}/yocto" \
  --volume="${HOST_DIR}/rzv2ma:/home/${USER}/yocto/rzv2ma" \
  --volume="${OSS_DIR}:/home/${USER}/oss_package" \
  --workdir="/home/${USER}/yocto" \
  rzv2ma_yocto:1.00
  
rm *.zip
docker container prune -f
