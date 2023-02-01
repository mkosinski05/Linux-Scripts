
SRCDIR=/media/zkmike/RZ/RZV2L
DL_DIR=/home/zkmike/workspace/yocto/oss_package
WORKDIR=~/workspace/yocto/RZV2L

BOARD=test
EDGE_IMPULSE_ENABLED=0
SIMPLE_ISP_ENABLED=0
ENABLE_BUILD=1
ENABLE_AI=0

setboard () {

	case $1 in
		rzv2l) 
			echo "rzv2l evk" 
			BOARD=rzv2l
			;;
		avnet) 
			echo "avnet rzboard" 
			# Avnet BSP requires ISP
			SIMPLE_ISP_ENABLED=1
			BOARD=rzboard
			;;
		rzboard) 
			echo "avnet rzboard" 
			# Avnet RZBoard BSP requires ISP
			SIMPLE_ISP_ENABLED=1
			BOARD=rzboard
			;;
		*) 
			echo "Custom baord (using rzv2l bsp build" 
			BOARD=$1
			;;
	esac
}

usage () {
	echo "Enter following Options"
	echo "-b board name (rzv2l rzboard) sets the subdirectory for Working Directory ( Default ${BOARD}}"
	echo "-w sets Working base directory ( Default ${WORKDIR}}"
	echo "-d Download Directory ( Default ${DL_DIR}}"
	echo "-s Source Directory ( Default ${SRCDIR}}"
	echo "-e Enable Edge Impulse"
	echo "-i Enables Sippe ISP Support"
	echo "-t Disables Build"
	echo "-a Add Software AI Framework ( Onnx Runtime = onnx, TensorfowLite = tfl, ARMNN = nn )"
	exit 0
}


if [[ $# -gt 0 ]]; then
	while getopts 'b:w:d:s:eita:h' c
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
		t) 
			echo "Build Disabled"
			ENABLE_BUILD=0
			;;
		a) 
			echo "AI Framwork enabled"
			case $OPTARG in
	
				onnx)
					echo "Onnx Runtime"
					ENABLE_AI=1
					;;
				tfl)
					echo "Tensorflow Lite"
					ENABLE_AI=2
					;;
				nn) 
					echo "ARMNN "
					ENABLE_AI=3
					;;
			esac
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
export ENABLE_BUILD=${ENABLE_BUILD}
export ENABLE_AI_FRAMEWORK=${ENABLE_AI}

my_dir="$(dirname "$0")"
if [[ ${BOARD} == *"rzv2l"* ]]; then
	bash ${my_dir}/rzv2l_build.sh
elif [[ ${BOARD} == *"rzboard"* ]]; then
	bash ${my_dir}/rzboard_build.sh
else
	bash ${my_dir}/rzv2l_build.sh
fi


