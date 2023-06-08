if [[ $1 == "V2MA" ]]; then
    docker build -t drp-ai_tvm_v2ma_image --build-arg SDK="/opt/poky/3.1.14" --build-arg PRODUCT="V2MA" .
elif [[ $1 == "V2M" ]]; then
    docker build -t drp-ai_tvm_v2m_image --build-arg SDK="/opt/poky/3.1.14" --build-arg PRODUCT="V2M" .
elif [[ $1 == "V2L" ]]; then
    docker build -t drp-ai_tvm_v2l_image --build-arg SDK="/opt/poky/3.1.17" --build-arg PRODUCT="V2L" .
else
    echo "Enter V2MA, V2M, or V2L"
fi
