SRC_DIR=/home/zkmike/source
DL_DIR=/home/zkmike/oss_package

pushd ${SRC_DIR}
LinuxBSP=`find ${SRC_DIR} -name RTK0EF0045Z0021AZJ-* -printf "%f\n"`
VideoCodec=`find ${SRC_DIR} -name RTK0EF0045Z15001ZJ-* -printf "%f\n"`
Graphic=`find ${SRC_DIR} -name RTK0EF0045Z13001ZJ-* -printf "%f\n"`
popd

echo "##############################################################################################"


WORK_DIR=rzg2l
echo "Work Directory : ${WORK_DIR}"
echo " Packages :"

echo ${LinuxBSP}
echo ${VideoCodec}
echo ${Graphic}

mkdir $WORK_DIR
echo $WORK_DIR
echo "##############################################################################################"

### Extract the BSP Linux package
cd $WORK_DIR 
if [ -f "${SRC_DIR}/${LinuxBSP}" ]; then
	unzip ${SRC_DIR}/${LinuxBSP}
	tar -xf ./${LinuxBSP::-4}/rzg_bsp_* -C .
else
	echo ""
fi

### Copy/Move the 'Mali Graphics library' Zip file (RTK0EF0045Z13001ZJ-v0.51_forV2L_EN.zip) under the BSP directory.
unzip ${SRC_DIR}/${Graphic}
tar -zxvf ${Graphic::-4}/meta-rz-features_graphics_*.tar.gz

### Copy/Move the 'MRZG2L Codec Library v0.4' Zip file (RTK0EF0045Z15001ZJ-v0.51_forV2L_EN.zip) under the BSP directory.
unzip ${SRC_DIR}/${VideoCodec}
tar zxvf ${VideoCodec::-4}/meta-rz-features_codec_*.tar.gz


if [ -f "${SRC_DIR}/${LinuxBSP}" ]; then
	### Set up the Yocto Environment and copy a default configuration
	source poky/oe-init-build-env
	cp ../meta-renesas/docs/template/conf/rzg2l-dev/*.conf ./conf

	#echo -e "DL_DIR = \"${DL_DIR}\"\n" >> conf/local.conf
	echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf
	echo -e "IMAGE_FSTYPES_remove += \"ext4\"\n" >> conf/local.conf

	# enable GDB Server
	echo -e "IMAGE_INSTALL_append = \" rpm openssh openssh-sftp-server openssh-scp gdbserver\"\n" conf/local.conf

	### Build
	bitbake core-image-bsp
	bitbake core-image-bsp -c populate_sdk

	echo rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${Graphic::-4}

	rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${Graphic::-4}
fi

