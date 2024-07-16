#!/bin/bash

SRC=/home/zkmike/source
YOCTO_DL_DIR=/home/zkmike/oss_package
YOCTO_WORK=${PWD}/ai_sdk4

mkdir ${YOCTO_WORK}
mkdir ${YOCTO_WORK}/src_setup

cd ${YOCTO_WORK}
unzip ${SRC}/RTK0EF0180F*_linux-src.zip -d ${YOCTO_WORK}/src_setup
tar -xvf ${YOCTO_WORK}/src_setup/rzv2h_ai-sdk_yocto_recipe_v*.tar.gz
cp  ${SRC}/patches/* ${YOCTO_WORK}

# Add Code with H.264 encode/decode and H.265 encode/decode
rm -rf ${YOCTO_WORK}/meta-rz-features/meta-rz-codecs
rm -rf ${YOCTO_WORK}/meta-rz-features/meta-rz-opencva

unzip ${SRC}/RTK0EF0192Z00001ZJ.zip
tar xvf RTK0EF0192Z00001ZJ/meta-rz-features.tar.gz -C ${YOCTO_WORK}

cd ${YOCTO_WORK}

# Apply Codec Patch
patch -p1 -d meta-renesas < ${WORK}/src_setup/RTK0EF0192Z00001ZJ/0001-rzv2h-conf-r9a09g057-Add-hwcodec-to-MACHINE_FEATURE.patch

# Get e-CON MIPI Camera Driver for e-con
patch -p1 -i e-CAM22_CURZ*.patch

# Apply ISU Patch ( this is in the latest release)
#pushd meta-renesas
#patch -p1 -i ../0001-rz-common-kernel-module-vspm-Support0vspm-isu-driver.patch
#popd


TEMPLATECONF=${YOCTO_WORK}/meta-renesas/meta-rzv2h/docs/template/conf/ source poky/oe-init-build-env

bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics
bitbake-layers add-layer ../meta-rz-features/meta-rz-drpai
bitbake-layers add-layer ../meta-rz-features/meta-rz-opencva
bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs
bitbake-layers add-layer ../meta-econsys

patch -p1 < ../0001-tesseract.patch


# Reduce memory Internet store downloads to OSS location
echo "DL_DIR = \"${YOCTO_DL_DIR}\"" >> ./conf/local.conf
#echo "SSTATE_DIR = \"${YOCTO_SSTATE_DIR}\"" >> ./conf/local.conf

# Remove temp files after build complete
echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf

# Add GDB Debug Support
MiIrecho "IMAGE_INSTALL_append = \" gdbserver\"" >> ./conf/local.conf
echo -e "BB_NUMBER_THREADS = '2'" >> conf/local.conf
echo -e "PARALLEL_MAKE = '-j 2'"  >> conf/local.conf

# Start Build
MACHINE=rzv2h-evk-ver1 bitbake core-image-weston
MACHINE=rzv2h-evk-ver1 bitbake core-image-weston -c populate_sdk

