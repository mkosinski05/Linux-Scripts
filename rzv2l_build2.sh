
WORK_DIR=$PWD/rzv2l_bsp_v0.8
### Extract the BSP Linux package
mkdir rzv2l_bsp_v0.8
tar -xf rzv2l_bsp_v080.tar.gz -C rzv2l_bsp_v0.8


### (only for PMIC boards) Apply additional patch for New PMIC edition boards
cd $WORK_DIR/meta-rzv
wget https://raw.githubusercontent.com/seebe/rzg_stuff/master/boards/rzv2l_smarc/bsp_v0.8_pmic_patch/0001-Support-RZ-V2L-Smarc-PMIC-edition-boards.patch
patch -p1 < 0001-Support-RZ-V2L-Smarc-PMIC-edition-boards.patch


### Copy/Move the 'Mali Graphics library' Zip file (RTK0EF0045Z13001ZJ-v0.51_forV2L_EN.zip) under the BSP directory.
cd $WORK_DIR
unzip ../RTK0EF0045Z13001ZJ-v0.51_EN.zip 
cd RTK0EF0045Z13001ZJ-v0.51_EN/proprietary
./copy_gfx_mmp.sh ../../meta-rzv

### Copy/Move the 'MRZG2L Codec Library v0.4' Zip file (RTK0EF0045Z13001ZJ-v0.51_forV2L_EN.zip) under the BSP directory.
cd $WORK_DIR
tar -xf ../RTK0EF0045Z15001ZJ_0_4_0.tar.bz2
cd RTK0EF0045Z15001ZJ_0_4_0
export BINDIR=$(pwd)
cd ../meta-rzv
sh docs/template/copyscript/copy_proprietary_software_omx.sh $BINDIR

### Copy/Move the 'DRP-AI Support' package file (rzv2l_meta-drpai_ver0.90.tar.gz) under the BSP directory.
### After exacting using the command below, this will add a new directory "meta-drpai" and file "rzv2l-drpai-conf.patch"
cd $WORK_DIR
tar -xvf ../rzv2l_meta-drpai_ver0.90.tar.gz

### Set up the Yocto Environment and copy a default configuration
cd $WORK_DIR
source poky/oe-init-build-env
ls ../
cp ../meta-rzv/docs/template/conf/smarc-rzv2l/*.conf ./conf/

### Copy/Move the 'Codec Library' package file (RTK0EF0045Z15001ZJ_0_4_0.tar.bz2) under the BSP directory.
tar -xvf RTK0EF0045Z15001ZJ_0_4_0.tar.bz2
cd meta-rzv
sh docs/template/copyscript/copy_proprietary_software_omx.sh  ../RTK0EF0045Z15001ZJ_0_4_0
cd ..

### Initialize Yocto Environment and copy prepared configuration files
source poky/oe-init-build-env
cp ../meta-rzv/docs/template/conf/smarc-rzv2l/*.conf ./conf/

### Apply the patch from the 'DRP-AI Support' package
### (the current directory should still be the 'build' directory)
patch -p2 < ../rzv2l-drpai-conf.patch

### Build
bitbake core-image-weston
bitbake core-image-weston -c populate_sdk
