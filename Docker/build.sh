#!/bin/bash

prefix="DRP-AI_Translator-v*-Linux-x86_64-Install"
if [ ! -e ${prefix} ]; then 
	echo "Download DRP-AI Translator"
	exit
fi

prefix="poky-"
for script_name in "${prefix}"*.sh; do
  if [ ! -e "$script_name" ]; then
    echo "Download SDK"
	exit
  fi
done



if [[ $1 == "V2MA" ]]; then
    docker build --file Dockerfile.rv2ma -t drp-ai_tvm_v2ma_image --build-arg SDK="/opt/poky/3.1.21" --build-arg PRODUCT="V2MA" .
    
elif [[ $1 == "V2M" ]]; then
    docker build --file Dockerfile.rv2m -t drp-ai_tvm_v2m_image --build-arg SDK="/opt/poky/3.1.21" --build-arg PRODUCT="V2M" .
    
elif [[ $1 == "V2L" ]]; then
    docker build --file Dockerfile.rv2l -t drp-ai_tvm_v2l_image --build-arg SDK="/opt/poky/3.1.21" --build-arg PRODUCT="V2L" .

elif [[ $1 == "V2H" ]]; then
    docker build --file Dockerfile.rv2h -t drp-ai_tvm_v2h_image --build-arg SDK="/opt/poky/3.1.21" --build-arg PRODUCT="V2H" .
        
else
    echo "Enter V2H, V2MA, V2M, or V2L as argument to this commad"
fi
