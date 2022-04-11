### Set up the Yocto Environment and copy a default configuration
source poky/oe-init-build-env


### Build
bitbake core-image-weston
bitbake core-image-weston -c populate_sdk
