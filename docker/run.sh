HOST_DIR=${PWD}


while getopts ":s:d:w:h" opt; do
	case $opt in
	s)
		SRC_DIR="${OPTARG}"
		;;
	d)
		OSS_DIR="${OPTARG}"
		;;
	w)
		HOST_DIR="${OPTARG}"
		;;
	:)
		echo " ERROR: Option -$OPTARG requires an argument"
		exit 1
		;;
	esac
done

if [ -z "$SRC_DIR" ]; then
	
	echo " ERROR: Path to Yocto Recipes (-s ) and Path to OSS Package ( -d) must be set"
	exit 1

fi

if [ -z "$SRC_DIR/Linux" ]; then
	
	echo " ERROR: Source Directory ${SRC_DIR} must contain the subfolders"
	echo " Linux"
	echo " e-con_Camera"
	echo " DRP-AI"
	echo " Multi-OS"
	exit 1

fi
	
docker container prune -f

if [ -n "$OSS_DIR" ]; then
	echo " Start Docker Container with specified yocto directory"
	docker run -it \
	  --name=rzv2l \
	  --volume="${HOST_DIR}:/home/${USER}/yocto" \
	  --volume="${SRC_DIR}:/home/${USER}/source" \
	  --volume="${OSS_DIR}:/home/${USER}/oss_package" \
	  --workdir="/home/${USER}/yocto" \
	  rzv2h_yocto:latest
	  
else
	echo " Start Docker Container with default "
	docker run -it \
	  --name=rzv2l \
	  --volume="${HOST_DIR}:/home/${USER}/yocto" \
	  --volume="${SRC_DIR}:/home/${USER}/source" \
	  --workdir="/home/${USER}/yocto" \
	  rzv2h_yocto:latest
fi
docker container prune -f

# ./Scripts/build.sh -b test -w /home/zkmike/yocto/ -s /home/zkmike/source/ -d /home/zkmike/oss_package/
