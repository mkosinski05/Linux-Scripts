
pushd ${SRC_DIR}
LinuxBSP=`find ${SRC_DIR} -name RTK0EF0045Z0024AZJ* -printf "%f\n"`

VideoCodec=`find ${SRC_DIR} -name RTK0EF0045Z15001ZJ* -printf "%f\n"`
Graphics=`find ${SRC_DIR} -name RTK0EF0045Z13001ZJ* -printf "%f\n"`
ISP=`find ${SRC_DIR} -name r11an0561ej* -printf "%f\n"`
DRP=`find ${SRC_DIR} -name r11an0549ej* -printf "%f\n"`
CM33=`find ${SRC_DIR} -name r01an6238ej* -printf "%f\n"`
popd

#ISP_ENABLED=0
#EDGEE_ENABLED=0
echo "##############################################################################################"

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
tar -zxvf ${Graphics::-4}/meta-rz-features_graphics_v1.4.tar.gz

### Copy/Move the 'MRZG2L Codec Library v0.4' Zip file (RTK0EF0045Z13001ZJ-v0.51_forV2L_EN.zip) under the BSP directory.
cd $WORK_DIR
unzip ${SRC_DIR}/${VideoCodec}
tar zxvf ${VideoCodec::-4}/meta-rz-features_codec_v1.0.1.tar.gz

### Setup the RZV2L MultiOS CM33 
### Install the and boot commands OpenAMP library
cd $WORK_DIR
unzip ${SRC_DIR}/${CM33} -d cm33
tar zxvf cm33/meta-rz-features.tar.gz

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

if [[ ENABLE_AI_FRAMEWORK -gt 0 ]]; then
	git clone https://github.com/mkosinski05/meta-renesas-ai.git
fi

## Reinsert the MultiOS recipe into the meta-rz-features/conf/layers.conf
cd $WORK_DIR
sed -i '/demos.inc/a include ${LAYERDIR}/include/openamp/openamp.inc' ./meta-rz-features/conf/layer.conf

### Set up the Yocto Environment and copy a default configuration
cd $WORK_DIR
source poky/oe-init-build-env
cp ../meta-renesas/docs/template/conf/smarc-rzv2l/*.conf ./conf

echo -e "DL_DIR = \"${DL_DIR}\"\n" >> conf/local.conf
echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf
echo -e "IMAGE_FSTYPES_remove += \"ext4\"\n" >> conf/local.conf

## Add Support for Application Debugging
# echo -e "IMAGE_INSTALL_append = \" rpm openssh openssh-sftp-server openssh-scp gdbserver\""  >> conf/local.conf
##  Required to Support LVGL GUI Framework
echo -e "IMAGE_INSTALL_append = \" libsdl2-dev\""  >> conf/local.conf

if [[ $EDGEE_ENABLED -eq 1 ]]; then
	mv -n ../meta-renesas/include/core-image-bsp.inc ../meta-renesas/include/core-image-bsp.inc_org

	grep -v "lttng" ../meta-renesas/include/core-image-bsp.inc_org >> ../meta-renesas/include/core-image-bsp.inc

	sed -i 's/CIP_CORE = \"1\"/CIP_CORE = \"0\"/' ./conf/local.conf
	echo -e "IMAGE_INSTALL_append = \" nodejs nodejs-npm \"" >> ./conf/local.conf
	echo -e "BBMASK = \"meta-renesas/recipes-common/recipes-debian\"" >> ./conf/local.conf

fi

if [[ ${ENABLE_DEBUG} -eq 1 ]] ; then
	sed -i '/INCOMPATIBLE_LICENSE/d' ./conf/local.conf
	echo -e "IMAGE_INSTALL_append = \" rpm openssh openssh-sftp-server openssh-scp gdbserver\"" >> ./conf/local.conf
	echo -e "PACKAGE_EXCLUDE += \" packagegroup-core-ssh-dropbear\"" >> ./conf/local.conf
fi

if [[ $ENABLE_BUILD -eq 1 ]]; then
### Build
#bitbake core-image-weston

echo "TOOLCHAIN_TARGET_TASK += \"kernel-devsrc\"" >> ./conf/local.conf
#
bitbake core-image-weston -c populate_sdk
fi

echo rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} ${Graphics::-4} ${ISP::-4} cm33 
cd $WORK_DIR
rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} ${Graphics::-4} ${ISP::-4} cm33 

