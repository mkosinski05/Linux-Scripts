if [[ $1 == "V2M" ]]; then
    if [ "$( docker container inspect -f '{{.State.Status}}' drp-ai_tvm_v2m_container )" == "exited" ]; then 
         echo "Restart drp-ai_tvm_v2m_container"
         docker start -ia  drp-ai_tvm_v2m_container
    else
        echo "Start drp-ai_tvm_v2m_container"
        docker run -it --name drp-ai_tvm_v2m_container \
        -v rzv2m_tvm:/drp-ai_tvm \
        -v $(pwd)/RZV2M:/root/RZV2M \
        -v $(pwd)/Scripts:/root/Scripts \
        drp-ai_tvm_v2m_image
    fi
elif [[ $1 == "V2MA" ]]; then
    if [ "$( docker container inspect -f '{{.State.Status}}' drp-ai_tvm_v2ma_container )" == "exited" ]; then 
         echo "Restart drp-ai_tvm_v2ma_container"
         docker start -ia  drp-ai_tvm_v2ma_container
    else
        echo "Start drp-ai_tvm_v2ma_container"
        docker run -it --name drp-ai_tvm_v2ma_container \
        -v rzv2ma_tvm:/drp-ai_tvm \
        -v $(pwd)/RZV2MA:/root/RZV2MA \
        -v $(pwd)/Scripts:/root/Scripts \
        drp-ai_tvm_v2ma_image
    fi
elif [[ $1 == "V2L" ]]; then
    if [ "$( docker container inspect -f '{{.State.Status}}' drp-ai_tvm_v2l_container )" == "exited" ]; then 
         echo "Restart drp-ai_tvm_v2l_container"
         docker start -ia  drp-ai_tvm_v2l_container
    else
        echo "Start drp-ai_tvm_v2l_container"
        docker run -it --name drp-ai_tvm_v2l_container \
        -v rzv2l_tvm:/drp-ai_tvm \
        -v $(pwd)/RZV2L:/root/RZV2L \
        -v $(pwd)/Scripts:/root/Scripts \
        drp-ai_tvm_v2l_image
    fi
elif [[ $1 == "V2H" ]]; then
    if [ "$( docker container inspect -f '{{.State.Status}}' drp-ai_tvm_v2h_container )" == "exited" ]; then 
         echo "Restart drp-ai_tvm_v2h_container"
         docker start -ia  drp-ai_tvm_v2h_container
    else
        echo "Start drp-ai_tvm_v2h_container"
        docker run -it --name drp-ai_tvm_v2h_container \
        -v rzv2l_tvm:/drp-ai_tvm \
        -v $(pwd)/RZV2L:/root/RZV2L \
        -v $(pwd)/Scripts:/root/Scripts \
        drp-ai_tvm_v2h_image
    fi
else
    echo "Enter V2MA, V2M, V2H, or V2L"
fi
