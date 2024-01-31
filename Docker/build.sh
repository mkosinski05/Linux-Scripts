#!/bin/bash

if [[ ! -f "DRP-AI_Translator-v*" ]]; then
	echo "Download DRP-AI Translator"
	exit
fi

if [[ ! -f "poky-*" ]]; then
	echo "Build and Download SDK"
	exit
fi


if [[ $1 == "V2MA" ]]; then
    docker build --file Dockerfile.r2ma -t drp-ai_tvm_v2ma_image --build-arg SDK="/opt/poky/3.1.14" --build-arg PRODUCT="V2MA" .
    
elif [[ $1 == "V2M" ]]; then
    docker build --file Dockerfile.r2m -t drp-ai_tvm_v2m_image --build-arg SDK="/opt/poky/3.1.14" --build-arg PRODUCT="V2M" .
    
elif [[ $1 == "V2L" ]]; then
    docker build --file Dockerfile.r2l -t drp-ai_tvm_v2l_image --build-arg SDK="/opt/poky/3.1.17" --build-arg PRODUCT="V2L" .

elif [[ $1 == "V2H" ]]; then
    echo "Currently Not Supported"
        
else
    echo "Enter V2H, V2MA, V2M, or V2L as argument to this commad"
fi
