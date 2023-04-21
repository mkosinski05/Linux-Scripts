SRC_DIR=/home/zkmike/source
DL_DIR=/home/zkmike/oss_package

pushd ${SRC_DIR}
LinuxBSP=`find ${SRC_DIR} -name r01an6514ej* -printf "%f\n"`
Codec=`find ${SRC_DIR} -name RTK0EF0131F02000SJ-* -printf "%f\n"`
OPENCV=`find ${SRC_DIR} -name r11an0650ej* -printf "%f\n"`
DRP=`find ${SRC_DIR} -name r11an0592ej* -printf "%f\n"`
popd

ISP_ENABLED=0
EDGEE_ENABLED=0
echo "##############################################################################################"


WORK_DIR=rzv2ma
echo "Work Directory : ${WORK_DIR}"
echo " Packages :"

echo ${LinuxBSP}
echo ${Codec}
echo ${OPENCV}
echo ${DRP}

#mkdir $WORK_DIR
echo $WORK_DIR
echo "##############################################################################################"

### Extract the BSP Linux package
cd $WORK_DIR 
if [ -f "${SRC_DIR}/${LinuxBSP}" ]; then
	unzip ${SRC_DIR}/${LinuxBSP}
	pushd ./${LinuxBSP::-4}/bsp
	BSP=`find . -name rzv2ma_bsp* -printf "%f\n"`
	echo $BSP
	popd
	tar -xf ./${LinuxBSP::-4}/bsp/${BSP} -C .
else
	echo ""
fi

### Copy/Move the 'Renesas Codec library' Zip file (RTK0EF0131F02000SJ-<version>.zip) under the BSP directory.
if [ -f "${SRC_DIR}/${Codec}" ]; then
	unzip ${SRC_DIR}/${Codec} -d Codec
	tar -zxvf Codec/meta-rz-features.tar.gz
fi

### Copy/Move the DRP Support archive file ( rr11an0549ej0500-rzv2l-drpai-sp.zip ) 
### Extract the 'DRP-AI Driver Support' package file (rzv2l_meta-drpai_ver0.90.tar.gz) under the BSP directory.
### After exacting using the command below, this will add a new directory "meta-drpai" and file "rzv2l-drpai-conf.patch"
if [ -f "${SRC_DIR}/${DRP}" ]; then
	unzip ${SRC_DIR}/${DRP} -d drp
	tar -xvf drp/rzv2ma_drpai-driver/meta-rz-features.tar.gz
fi

### Copy/Move the OpenCV Accelerator archive file
### Extract the 'OpenCV Accelerator' pacage file (meta-rz-features.tar.gz)
if [ -f "${SRC_DIR}/${OPENCV}" ]; then
	unzip ${SRC_DIR}/${OPENCV} 
	tar -xvf drp/rzv2ma_drpai-driver/meta-rz-features.tar.gz
	tar -xvf ${OPENCV::-4}/meta-rz-features.tar.gz
fi


if [ -f "${SRC_DIR}/${LinuxBSP}" ]; then
	### Set up the Yocto Environment and copy a default configuration
	source poky/oe-init-build-env
	cp ../meta-renesas/docs/template/conf/rzv2ma/*.conf ./conf

	#echo -e "DL_DIR = \"${DL_DIR}\"\n" >> conf/local.conf
	echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf
	echo -e "IMAGE_FSTYPES_remove += \"ext4\"\n" >> conf/local.conf


	### Build
	bitbake core-image-bsp
	bitbake core-image-bsp -c populate_sdk

	echo rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${OPENCV::-4}

	rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${OPENCV::-4} 
fi

