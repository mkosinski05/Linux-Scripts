
SRCDIR=/media/zkmike/RZ/RZV2L
DL_DIR=/home/zkmike/workspace/yocto/oss_package
WORKDIR=~/workspace/yocto/RZV2L
DL_DIR=/home/zkmike/workspace/yocto/oss_package

BOARD=test
EDGE_IMPULSE_ENABLED=0
SIMPLE_ISP_ENABLED=0


setboard () {

	case $1 in
		rzv2l) 
			echo "rzv2l evk" 
			BOARD=rzv2l
			;;
		rzboard) 
			echo "avnet rzboard" 
			BOARD=rzboard
			;;
		test)
			echo "Test" 
			BOARD=test
			;;
		*) echo "Board Not Supported" ;;
	esac
}

usage () {
	echo "Enter following Options"
	echo "-b board name (rzv2l rzboard) sets the subdirectory for Working Directory"
	echo "-w sets Working base directory"
	echo "-d Download Directory"
	echo "-s Sopurce Directory"
	echo "-e Enable Edge Impulse"
	echo "-i Enables Sippe ISP Support"
	exit 0
}


if [[ $# -gt 0 ]]; then
	while getopts 'b:w:d:s:eih' c
	do
	  case $c in
		b) setboard $OPTARG ;;
		d) DL_DIR=$OPTARG ;;
		w) WORKDIR=$OPTARG ;;
		s) SRCDIR=$OPTARG ;;
		e) 
			echo "Edge Enabled" 
			EDGE_IMPULSE_ENABLED=1
			;;
		i) 
			echo "ISP Enabled"
			SIMPLE_ISP_ENABLED=1 
			;;
		h|?) usage ;;
	  esac
	done
else
	usage
	exit 0
fi

if [[ EDGE_IMPULSE_ENABLED -eq 1 ]]; then
	export BOARD="${BOARD}_edge"
fi
if  [[ SIMPLE_ISP_ENABLED -eq 1 ]]; then
	export BOARD="${BOARD}_isp"
fi

export WORK_DIR=${WORKDIR}/${BOARD}
export SRC_DIR=${SRCDIR}
export ISP_ENABLED=${SIMPLE_ISP_ENABLED}
export EDGEE_ENABLED=${EDGE_IMPULSE_ENABLED}
export DL_DIR=${DL_DIR}

my_dir="$(dirname "$0")"
if [[ ${BOARD} == *"rzv2l"* ]]; then
	bash ${my_dir}/rzv2l_build.sh
elif [[ ${BOARD} == *"rzboard"* ]]; then
	bash ${my_dir}/rzboard_build.sh
elif [[ ${BOARD} == *"test"* ]]; then
	bash ${my_dir}/rzv2l_build.sh
fi


