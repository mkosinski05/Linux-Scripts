ENABLE=0

if [[ ! -f Dockerfile ]]; then
	wget https://raw.githubusercontent.com/renesas-rz/rzv_drp-ai_tvm/main/Dockerfile
fi
if [[ $ENABLE -eq 1 ]]; then

	if [[ ! -f "DRP-AI_Translator-v*" ]]; then
		echo "Download DRP-AI Translator"
		exit
	fi

	if [[ ! -f "poky-*" ]]; then
		echo "Build and Download SDK"
		exit
	fi
fi

if [[ $1 == "V2MA" ]]; then
    docker build -t drp-ai_tvm_v2ma_image --build-arg SDK="/opt/poky/3.1.14" --build-arg PRODUCT="V2MA" .
elif [[ $1 == "V2M" ]]; then
    docker build -t drp-ai_tvm_v2m_image --build-arg SDK="/opt/poky/3.1.14" --build-arg PRODUCT="V2M" .
elif [[ $1 == "V2L" ]]; then
    docker build -t drp-ai_tvm_v2l_image --build-arg SDK="/opt/poky/3.1.17" --build-arg PRODUCT="V2L" .
else
    echo "Enter V2MA, V2M, or V2L"
fi
