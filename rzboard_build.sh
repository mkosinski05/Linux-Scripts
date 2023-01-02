
# https://github.com/Avnet/meta-rzboard

pushd ${SRC_DIR}
LinuxBSP=`find ${SRC_DIR} -name RTK0EF0045Z0024AZJ* -printf "%f\n"`

VideoCodec=`find ${SRC_DIR} -name RTK0EF0045Z15001ZJ* -printf "%f\n"`
Graphics=`find ${SRC_DIR} -name RTK0EF0045Z13001ZJ* -printf "%f\n"`
ISP=`find ${SRC_DIR} -name r11an0561ej* -printf "%f\n"`
DRP=`find ${SRC_DIR} -name r11an0549ej* -printf "%f\n"`
CM33=`find ${SRC_DIR} -name r01an6238ej* -printf "%f\n"`
popd


echo "##############################################################################################"


echo "Avnet RZBOARD"

echo "Work Directory : ${WORK_DIR}"
echo " Packages :"

echo ${LinuxBSP}
echo ${VideoCodec}
echo ${Graphics}
echo ${ISP}
echo ${DRP}
echo ${CM33}

mkdir $WORK_DIR
echo "##############################################################################################"

function remove_redundant_patches(){
	# remove linux patches that were merged into the Avnet kernel
	flist=$(find ${YOCTO_HOME} -name "linux-renesas_*.bbappend")
	for ff in ${flist}
	do
		echo ${ff}
		rm -rf ${ff}
	done

	# remove u-boot patches
	find ${YOCTO_HOME} -name "u-boot_*.bbappend" -print -exec rm -rf {} \;

	# remove tfa patches
	find ${YOCTO_HOME} -name "trusted-firmware-a.bbappend" -print -exec mv {} {}.remove \;
}

### Extract the BSP Linux package
cd $WORK_DIR 
unzip ${SRC_DIR}/${LinuxBSP}
pushd ./${LinuxBSP::-4}
BSP=`find . -name rzv_bsp* -printf "%f\n"`
echo $BSP
popd
tar -xf ./${LinuxBSP::-4}/${BSP} -C .

### Copy/Move the 'Mali Graphics library' Zip file (RTK0EF0045Z13001ZJ-v0.51_forV2L_EN.zip) under the BSP directory.
cd $WORK_DIR
unzip ${SRC_DIR}/${Graphics}
tar -zxvf ${Graphics::-4}/meta-rz-features.tar.gz

### Copy/Move the 'MRZG2L Codec Library v0.4' Zip file (RTK0EF0045Z13001ZJ-v0.51_forV2L_EN.zip) under the BSP directory.
cd $WORK_DIR
unzip ${SRC_DIR}/${VideoCodec}
tar zxvf ${VideoCodec::-4}/meta-rz-features.tar.gz

### Setup the RZV2L MultiOS CM33 
### Install the and boot commands OpenAMP library
cd $WORK_DIR
unzip ${SRC_DIR}/${CM33}
tar zxvf ${CM33::-4}/meta-rz-features.tar.gz

### Copy/Move the DRP Support archive file ( rr11an0549ej0500-rzv2l-drpai-sp.zip ) 
### Extract the 'DRP-AI Driver Support' package file (rzv2l_meta-drpai_ver0.90.tar.gz) under the BSP directory.
### After exacting using the command below, this will add a new directory "meta-drpai" and file "rzv2l-drpai-conf.patch"
cd $WORK_DIR
unzip ${SRC_DIR}/${DRP} -d drp
tar -xvf drp/rzv2l_drpai-driver/meta-rz-features.tar.gz

if [[ $ISP_ENABLED -eq 1 ]]; then
	### Copy/Move the ISP Support archive file ( r11an0561ej0100-rzv2l-isp-sp.zip ) 
	### Extract the ISP Support Package ( rzv2l_meta-isp_ver1.00.tar.gz ) nder the BSP directory.
	### After exacting using the command below, this will add a new directory "meta-isp" and file "rzv2l-isp-conf.patch"
	cd $WORK_DIR
	unzip ${SRC_DIR}/${ISP}
	tar -zxvf ./${ISP::-4}/meta-rz-features.tar.gz
fi

## Reinsert the MultiOS recipe into the meta-rz-features/conf/layers.conf
cd $WORK_DIR
sed -i '/demos.inc/a include ${LAYERDIR}/include/openamp/openamp.inc' ./meta-rz-features/conf/layer.conf

remove_redundant_patches

# Setup Avnet Board
git clone https://github.com/Avnet/meta-rzboard.git -b rzboard_dunfell_5.10

### Set up the Yocto Environment and copy a default configuration
cd $WORK_DIR
source poky/oe-init-build-env
cp ../meta-rzboard/conf/rzboard/*.conf ./conf

echo -e "DL_DIR = \"${DL_DIR}\"\n" >> conf/local.conf
echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf
echo -e "IMAGE_FSTYPES_remove += \"ext4\"\n" >> conf/local.conf

if [[ $EDGEE_ENABLED -eq 1 ]]; then
	mv -n ../meta-renesas/include/core-image-bsp.inc ../meta-renesas/include/core-image-bsp.inc_org

	grep -v "lttng" ../meta-renesas/include/core-image-bsp.inc_org >> ../meta-renesas/include/core-image-bsp.inc

	sed -i 's/CIP_CORE = \"1\"/CIP_CORE = \"0\"/' ./conf/local.conf
	echo -e "IMAGE_INSTALL_append = \" nodejs nodejs-npm \""
	echo -e "BBMASK = \"meta-renesas/recipes-common/recipes-debian\""

fi

### Build
bitbake avnet-core-image
bitbake avnet-core-image -c populate_sdk

echo rm -rfd drp drp ${LinuxBSP::-4} ${VideoCodec::-4} ${Graphics::-4} ${ISP::-4} ${CM33::-4} 
cd $WORK_DIR
rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} ${Graphics::-4} ${ISP::-4} ${CM33::-4} 

