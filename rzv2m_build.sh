
# Create Working Build directory
mkdir ./rzv2m_bsp_v110

# Extract the rzv2m bsp to the working directory
tar -xvf rzv2m_bsp_eva_v110.tar.gz -C ./rzv2m_bsp_v110

# Extract the rzv2m DRP-AI bsp to the working directory
tar -xvf rzv2m_meta-drpai_ver5.00.tar.gz -C ./rzv2m_bsp_v110

# Extract the RZV2M ISP to the working directory
tar -xvf rzv2m_isp_support-pkg_v110.tar.gz -C ./rzv2m_bsp_v110

cd rzv2m_bsp_v110

# Initialize Yocto build environment
source poky/oe-init-build-env

# Apply RZV2M build configuation files
cp ../meta-rzv2m/docs/sample/conf/rzv2m/linaro-gcc/*.conf ./conf/

# Apply DRP-AI Patch
patch -p2 < ../rzv2m-drpai-conf.patch

# Apply ISP Patch
patch -p2 < ../rzv2m-isp-conf.patch

# Start Yocto Build
bitbake core-image-bsp
bitbake core-image-bsp -C populate_sdk

# Error fetching linaro gcc toolcahin from https://git.linaro.org/toolchain/gcc.git/':
# gcc-source-linaro-7.3-linaro-7.3-r2018.05 do_fetch: 
