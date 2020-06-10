# Install Base Ubuntu Docker Image version 16.04
# Yocto for RZG2E Requires ubuntu 16.04
FROM ubuntu:16.04


# Install the required software for yocto
RUN apt-get update && apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping libsdl1.2-dev xterm p7zip-full tar locales

RUN apt-get install -y autoconf2.13 clang llvm clang-3.9 llvm-3.9

# In Ubuntu, /bin/sh is a link to /bin/dash. The dash shell does not support the source command. However, 
# we need the source command in the very last line of the Dockerfile. We replace dash by bash with
RUN rm /bin/sh && ln -s bash /bin/sh

# Yocto Requires UTF8-capable locale
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
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
    
# switches the user from root to $USER_NAME.    
USER $user_name

ENV BUILD_INPUT_DIR /home/$user_name/yocto
ENV BUILD_OUTPUT_DIR /home/$user_name/yocto/build
RUN mkdir -p $BUILD_INPUT_DIR $BUILD_INPUT_DIR/proprietary
RUN mkdir -p $BUILD_OUTPUT_DIR $BUILD_OUTPUT_DIR/conf

WORKDIR $BUILD_INPUT_DIR
ADD $PWD/rzg2_bsp_eva_v102.tar.gz .

USER root
RUN chown -R $host_uid:$host_gid .
USER $user_name

WORKDIR $BUILD_INPUT_DIR/meta-rzg2
RUN sh ./docs/sample/copyscript/copy_proprietary_softwares.sh ../proprietary

WORKDIR $BUILD_INPUT_DIR
RUN cp ./meta-rzg2/docs/sample/conf/ek874/linaro-gcc/*.conf ./build/conf/

CMD source poky/oe-init-build-env \
    build && bitbake linux-renesas -c fetch && bitbake core-image-weston
