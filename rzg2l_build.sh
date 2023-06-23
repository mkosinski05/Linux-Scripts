SRC_DIR=/home/zkmike/source
DL_DIR=/home/zkmike/oss_package
WORK_DIR=${PWD}/rzg2l

pushd ${SRC_DIR}
LinuxBSP=`find ${SRC_DIR} -name RTK0EF0045Z0021AZJ-* -printf "%f\n"`
VideoCodec=`find ${SRC_DIR} -name RTK0EF0045Z15001ZJ-* -printf "%f\n"`
Graphic=`find ${SRC_DIR} -name RTK0EF0045Z13001ZJ-* -printf "%f\n"`
popd

echo "##############################################################################################"

ENABLE_AI_FRAMEWORK=0



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

cd $WORK_DIR/meta-renesas
patch -p1 < ../extra/0001-Add-HDMI-support-for-RZ-G2.patch
cd $WORK_DIR


if [ -f "${SRC_DIR}/${LinuxBSP}" ]; then
	### Set up the Yocto Environment and copy a default configuration
	TEMPLATECONF=$PWD/meta-renesas/meta-rzg2l/docs/template/conf/ source \
    poky/oe-init-build-env build
    
    if [[ -d $1 ]]; then
        mv $1 build
    fi
    # Add Layeres
    bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics
    bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs
    bitbake-layers add-layer ../meta-qt5

	echo -e "DL_DIR = \"${DL_DIR}\"\n" >> conf/local.conf
	echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf
	echo -e "IMAGE_FSTYPES_remove += \"ext4\"\n" >> conf/local.conf

	# enable GDB Server
	## echo -e "IMAGE_INSTALL_append = \" rpm openssh openssh-sftp-server openssh-scp gdbserver\"\n" conf/local.conf

    if [[ $ENABLE_AI_FRAMEWORK -eq 1 ]]; then
        echo "ENABLE AI FRAMEWORKS"
        # Dwonload meta-renesas-ai
        #git clone https://github.com/mkosinski05/meta-renesas-ai.git ../
        unzip ${SRC_DIR}/meta-renesas-ai-master.zip -d ${WORK_DIR}
        mv ${WORK_DIR}/meta-renesas-ai-master ${WORK_DIR}/meta-renesas-ai
        
        # Add layer
        ## bitbake-layers add-layer ${WORK_DIR}/meta-renesas-ai 
        bitbake-layers add-layer ../meta-renesas-ai
                
        sed -i 's/CIP_MODE = "Buster"/CIP_MODE = "None"/g' ./conf/local.conf
        
        # Add AI packages to local.conf
        echo 'IMAGE_INSTALL_append = " armnn-dev armnn-examples armnn-tensorflow-lite-dev armnn-onnx-dev armnn-onnx-examples tensorflow-lite-python"' >> ./conf/local.conf
        
        # Add Bencmarks
        echo 'IMAGE_INSTALL_append = " tensorflow-lite-staticdev tensorflow-lite-dev tensorflow-lite-benchmark armnn-benchmark"' >> ./conf/local.conf
        echo 'IMAGE_INSTALL_append = " tensorflow-lite-delegate-benchmark"' >> ./conf/local.conf


    fi
	### Build
	MACHINE=smarc-rzg2l  bitbake core-image-weston
	MACHINE=smarc-rzg2l bitbake core-image-weston -c populate_sdk

	echo rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${Graphic::-4}

	rm -rfd drp ${LinuxBSP::-4} ${VideoCodec::-4} Codec ${Graphic::-4}
fi

