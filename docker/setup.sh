
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
--build-arg "USERNAME=$(whoami)" \
--build-arg "host_gid=$(id -g)" \
--build-arg "TZ_VALUE=$(cat /etc/timezone)" \
--file Dockerfile.rzv_ubuntu-20.04 \
--tag "rzv2_yocto:1.00" .



