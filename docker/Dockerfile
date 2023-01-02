# Install Base Ubuntu Docker Image version 16.04
# Yocto for RZV2M Requires ubuntu 16.04
FROM ubuntu:18.04


# Install the required software for yocto
RUN apt-get update && apt-get install -y gawk wget git-core diffstat unzip texinfo \
gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping libsdl1.2-dev xterm p7zip-full tar locales tmux

RUN apt-get install -y autoconf2.13 clang llvm clang-3.9 llvm-3.9

# In Ubuntu, /bin/sh is a link to /bin/dash. The dash shell does not support the source command. However, 
# we need the source command in the very last line of the Dockerfile. We replace dash by bash with
RUN rm /bin/sh && ln -s bash /bin/sh

# Yocto Requires UTF8-capable locale
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 \
#    LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Yocto is not run as root but as a non-root user 
# By Default Ubuntu image only has root
# These enviroment variables will help setup a user
# The user can only access the host directory, if user ID is the same as the user ID of the host directory’s owner.
ARG user_name=rea_user
ENV PROJECT $user_name


ARG host_uid=1000
ARG host_gid=1000
RUN echo $host_uid && echo $host_gid
RUN groupadd -g $host_gid $user_name && \
    useradd -g $host_gid -m -s /bin/bash -u $host_uid $user_name
    
ARG ver_bsp=v102
RUN echo $ver_bsp  
# switches the user from root to $USER_NAME.    
USER $user_name

ENV BUILD_INPUT_DIR /home/$user_name/rzv2m
#ENV SRC_DIR /media/zkmike/0DF83D052A378594/Renesas/RZV/RZV2M/v0102

# Configure git using the login user name and gmiail
# NOTE: this is required for yocto but does not need to be a real git account
RUN git config --global user.email "$user_name.gmail.com"
RUN git config --global user.name $user_name
RUN git config --global url.https://github.com/.insteadOf git://github.com/

WORKDIR $BUILD_INPUT_DIR

COPY ./r01an5971ej0120-rzv2m-linux.zip .
COPY ./r11an0530ej0600-rzv2m-drpai-sp.zip .
COPY ./r01an5978ej0120-rzv2m_isp-support.zip .

USER root
RUN chown -R $host_uid:$host_gid .
USER $user_name

RUN unzip r01an5971ej0120-rzv2m-linux.zip
RUN tar -zxvf ./r01an5971ej0120-rzv2m-linux/bsp/rzv2m_bsp_eva_v120.tar.gz
RUN rm -rfd r01an5971ej0120-rzv2m-linux
RUN rm r01an5971ej0120-rzv2m-linux.zip

 
RUN unzip r11an0530ej0600-rzv2m-drpai-sp.zip
RUN tar -zxvf ./r11an0530ej0600-rzv2m-drpai-sp/rzv2m_drpai-driver/rzv2m_meta-drpai_ver6.00.tar.gz
RUN rm -rfd r11an0530ej0600-rzv2m-drpai-sp
RUN rm r11an0530ej0600-rzv2m-drpai-sp.zip

### Extract the ISP Linux Package
RUN unzip r01an5978ej0120-rzv2m_isp-support.zip
RUN tar -zxvf ./r01an5978ej0120-rzv2m_isp/rzv2m_isp_support-pkg_v120.tar.gz
RUN rm -rfd r01an5978ej0120-rzv2m_isp-support
RUN rm r01an5978ej0120-rzv2m_isp-support.zip

# Initialize Yocto Build System
RUN source poky/oe-init-build-env

# Compy RZV2M BSP Yocto Configuratino Files 
WORKDIR $BUILD_INPUT_DIR/build
RUN cp ../meta-rzv2m/docs/sample/conf/rzv2m/linaro-gcc/*.conf ./conf/

# Apply Patches
# Apply DRP Patch first
RUN patch -p2 < ../rzv2m-drpai-conf.patch
# Apply ISP Patch Second
RUN patch -p2 < ../rzv2m-isp-conf.patch
 

WORKDIR $BUILD_INPUT_DIR
COPY start.sh start.sh

#CMD source poky/oe-init-build-env build && bitbake linux-renesas -c fetch && bitbake core-image-weston
ENTRYPOINT ["bash","./start.sh"]
