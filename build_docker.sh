SRC_DIR=~/yocto
DL_DIR=/home/zkmike/oss_package

LinuxBSP=`find ${SRC_DIR} -name r01an6514ej0100-* -printf "%f\n"`
Codec=`find ${SRC_DIR} -name RTK0EF0131F02000SJ-* -printf "%f\n"`
OPENCV=`find ${SRC_DIR} -name r11an0650ej0100-* -printf "%f\n"`
DRP=`find ${SRC_DIR} -name r11an0592ej0720-* -printf "%f\n"`


ISP_ENABLED=0
EDGEE_ENABLED=0
echo "##############################################################################################"


WORK_DIR=~/yocto/rzv2ma
echo "Work Directory : ${WORK_DIR}"
echo "Source Directory : ${SRC_DIR}"
echo " Packages :"

echo ${LinuxBSP}
echo ${Codec}
echo ${OPENCV}
echo ${DRP}

mkdir $WORK_DIR
echo "##############################################################################################"

### Extract the BSP Linux package
cd $WORK_DIR 
unzip ${SRC_DIR}/${LinuxBSP}
pushd ./${LinuxBSP::-4}/bsp
BSP=`find . -name rzv2ma_bsp* -printf "%f\n"`
echo $BSP
popd
tar -xf ./${LinuxBSP::-4}/bsp/${BSP} -C .


### Copy/Move the 'Renesas Codec library' Zip file (RTK0EF0131F02000SJ-<version>.zip) under the BSP directory.
cd $WORK_DIR
unzip ${SRC_DIR}/${Codec} -d Codec
tar -zxvf Codec/meta-rz-features.tar.gz

### Copy/Move the DRP Support archive file ( rr11an0549ej0500-rzv2l-drpai-sp.zip ) 
### Extract the 'DRP-AI Driver Support' package file (rzv2l_meta-drpai_ver0.90.tar.gz) under the BSP directory.
### After exacting using the command below, this will add a new directory "meta-drpai" and file "rzv2l-drpai-conf.patch"
cd $WORK_DIR
unzip ${SRC_DIR}/${DRP} -d drp
tar -xvf drp/rzv2ma_drpai-driver/meta-rz-features.tar.gz


### Copy/Move the OpenCV Accelerator archive file
### Extract the 'OpenCV Accelerator' pacage file (meta-rz-features.tar.gz)
cd $WORK_DIR
unzip ${SRC_DIR}/${OPENCV} 
tar -xvf drp/rzv2ma_drpai-driver/meta-rz-features.tar.gz
tar -xvf ${OPENCV::-4}/meta-rz-features.tar.gz



### Set up the Yocto Environment and copy a default configuration
cd $WORK_DIR
source poky/oe-init-build-env
cp ../meta-renesas/docs/template/conf/rzv2ma/*.conf ./conf

#echo -e "DL_DIR = \"${DL_DIR}\"\n" >> conf/local.conf
echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf
echo -e "IMAGE_FSTYPES_remove += \"ext4\"\n" >> conf/local.conf


### Build
bitbake core-image-bsp
bitbake core-image-bsp -c populate_sdk

echo rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${OPENCV::-4}
cd $WORK_DIR
rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${OPENCV::-4} 

