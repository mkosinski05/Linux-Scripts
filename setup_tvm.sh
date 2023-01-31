
cd ${TVM_DEV}
git clone --recursive https://github.com/renesas-rz/rzv_drp-ai_tvm.git drp-ai_tvm

if [ ! -d "/opt/onnxruntime-linux-x64-1.8.1" ]; then

    wget https://github.com/microsoft/onnxruntime/releases/download/v1.8.1/onnxruntime-linux-x64-1.8.1.tgz -O /tmp/onnxruntime.tar.gz
    tar -xvzf /tmp/onnxruntime.tar.gz -C /tmp/
    mv /tmp/onnxruntime-linux-x64-1.8.1/ /opt/
fi

cd ${TVM_ROOT}
bash setup/make_drp_env.sh
