### Set up the Yocto Environment and copy a default configuration
source poky/oe-init-build-env
cp ../meta-rzv/docs/template/conf/smarc-rzv2l/*.conf ./conf/
cd ..

### Copy/Move the 'Codec Library' package file (RTK0EF0045Z15001ZJ_0_4_0.tar.bz2) under the BSP directory.
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
