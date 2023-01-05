
###############################################################################
# Arguments : 
#	host_uid	User UID number
#	ver_bsp		passes the bsp version
#	USERNAME	User name
#	host_gid	User Group ID number
#
# tag	Namer and verion of the Created container
# file	Specifies the Doker file if not specitied Dockerfile is used
#
###############################################################################

docker build --no-cache --rm \
--build-arg "host_uid=$(id -u)" \
--build-arg "ver_bsp=v102" \
--build-arg "USERNAME=$(whoami)" \
--build-arg "host_gid=$(id -g)" \
--file Dockerfile.rzg_ubuntu-20.04 \
--tag "rzv2_yocto:1.00" .



