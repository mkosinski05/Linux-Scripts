# RZGL DockerFile

## RZG2L Docker Environment

The purpose of this Dockerfile is to build the RZG2L images and store them on the Host PC.

This docker setup the yocto environment when the docker image is built. The yocto is built and output to the host in the host build directory when the docker run command below is called. A docker run for this image can take 3 - 6 hours depending on the Host PC used. When the container is complete it is existed and removed. The output persists in the build directory. 

- #### Requirements

  rzg2l_bsp_v1.1.tar.gz  - this is the Renesas Yocto archive for RZG2L. This can be found on the Renesas website [here](https://www.renesas.com/us/en/products/microcontrollers-microprocessors/rz-arm-based-high-end-32-64-bit-mpus/rzg2l-multi-os-package).

  Weston GUI Support requires RTK0EF0045Z13001ZJ-v0.51_EN.zip. This can be found on the Renesas website [here](https://www.renesas.com/us/en/products/microcontrollers-microprocessors/rz-arm-based-high-end-32-64-bit-mpus/rzg2l-multi-os-package).
  
  Build the Image


The build command below takes three arguments host_uid, host_id, and host user name. These are needed to setup a user account on the yocto image. Yocto Buildsystem requires user not root login. The --rm removes extra images created during build.

    docker build --no-cache --rm --build-arg "host_uid=$(id -u)" \
    --build-arg "ver_bsp=v1.1" \
    --build-arg "user_name=$(whoami)" \
    --build-arg "gui_zip_file_name=RTK0EF0045Z13001ZJ-v0.51_EN" \
    --build-arg "host_gid=$(id -g)" --tag "rzg2l_yocto:1.1" .

- ### Run the image

The docker run command creates the docker executable container. This innates a yocto build. The output of the yocto build is stored in the host directory specified after the -v flag. This matches the container out director "/home/$(whoami)/yocto/input/build". 

This should be run where you want the yocto output to be or change the host mount directory.

    docker run -it --rm --name rzg2l -v $PWD:/yocto/build rzg2l_yocto:1.1

## Cleanup
I added these helper commands for cleanup of extra containers and images due to errors in building and running docker image and container. Using the Dockerfile as is, these commands are not needed as the build and run commands cleanup the system. If changes are made to the Docker File 

Remove all stopped Containers

```
docker rm $(docker ps -a -q)
```

Remove all images created after Ubuntu 16.04


```
docker image rm $(docker images --filter 'since=ubuntu:16.04')
```



