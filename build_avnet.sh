DL_DIR=/home/zkmike/workspace/yocto/oss_package
mkdir ~/workspace/yocto/RZV2L/rzboard
cd ~/workspace/yocto/RZV2L/rzboard

# Download Poky
git clone https://git.yoctoproject.org/git/poky
cd poky
git checkout dunfell-23.0.5
git cherry-pick 9e44438a9deb7b6bfac3f82f31a1a7ad138a5d16
cd ../

# Download Open Embedded
git clone https://github.com/openembedded/meta-openembedded
cd meta-openembedded
git checkout cc6fc6b1641ab23089c1e3bba11e0c6394f0867c
cd ../

# Download meta-gplv2
git clone https://git.yoctoproject.org/git/meta-gplv2 -b dunfell
cd meta-gplv2
git checkout 60b251c25ba87e946a0ca4cdc8d17b1cb09292ac
cd ../

# Download Renesas meta
git clone https://github.com/Avnet/meta-renesas.git -b dunfell_rzv2l_bsp_v100

# Download Avnet meta-rzboard
git clone https://github.com/Avnet/meta-renesas.git -b dunfell_rzv2l_bsp_v100

source poky/oe-init-build-env
cp meta-rzboard/conf/rzboard/* build/conf/

echo -e "DL_DIR = \"${DL_DIR}\"\n" >> conf/local.conf
echo -e "INHERIT += \"rm_work\"\n" >> conf/local.conf
echo -e "IMAGE_FSTYPES_remove += \"ext4\"\n" >> conf/local.conf

bitbake core-image-weston
