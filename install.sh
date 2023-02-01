SRC=/media/zkmike/RZ/RZV2L
# Step 1. Preparations
# Download the DRP-AI Support Package from Renesas Web Page.
# To use the DRP-AI Support Package, Linux Package is required.
# Linux Package can be found in the page of DRP-AI Support Package.

unzip $SRC/*translator.zip -d translator
chmod +x ./translator/DRP-AI_Translator-v1.81-Linux-x86_64-Install
./translator/DRP-AI_Translator-v1.81-Linux-x86_64-Install

# Build image/SDK according to the DRP-AI Support Package Release Note to generate following files.
if [[ -d "/opt/poky" ]]; then

	SDKS=`ls /opt/poky`
	if [[ #SDKS[@] -eq 0 ]]; then
		echo "No SDK installed"
		exit
	fi
else
	echo "No SDK installed"
	exit
fi

# Step 2. Clone the repository
git clone --recursive https://github.com/renesas-rz/rzv_drp-ai_tvm.git drp-ai_tvm

# Step 3. Set environment varables

source set_env.sh

# Step 4.Install the minimal pre-requisites
# Install packagess
apt update
DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test
apt update
DEBIAN_FRONTEND=noninteractive apt install -y build-essential cmake \
libomp-dev libgtest-dev libgoogle-glog-dev libtinfo-dev zlib1g-dev libedit-dev \
libxml2-dev llvm-8-dev g++-9 gcc-9 wget

apt-get install -y python3-pip
pip3 install --upgrade pip
apt-get -y install unzip vim
pip3 install decorator attrs scipy numpy==1.23.5 pytest
pip3 install torch==1.8.0 torchvision==0.9.0

# Install onnx runtime
if [ ! -d "/opt/onnxruntime-linux-x64-1.8.1" ]; then
	wget https://github.com/microsoft/onnxruntime/releases/download/v1.8.1/onnxruntime-linux-x64-1.8.1.tgz -O /tmp/onnxruntime.tar.gz
	tar -xvzf /tmp/onnxruntime.tar.gz -C /tmp/
	mv /tmp/onnxruntime-linux-x64-1.8.1/ /opt/
fi

# Step 5.  Setup DRP-AI TVM1 environment
cd <.../drp-ai_tvm>
bash setup/make_drp_env.sh

# Step 6. Create Symblic Links
# Setup AI Translator 
[ ! -f run_DRP-AI_translator_V2M.sh ] && ln -s ~/workspace/TVM/drp-ai_translator_release/run_DRP-AI_translator_V2M.sh .
[ ! -f run_DRP-AI_translator_V2L.sh ] && ln -s ~/workspace/TVM/drp-ai_translator_release/run_DRP-AI_translator_V2L.sh .
[ ! -d DRP-AI_translator ] && ln -s ~/workspace/TVM/drp-ai_translator_release/DRP-AI_translator .


# Setup TVM
[ ! -f compile_onnx_model.py ] && ln -s ${TVM_ROOT}/tutorials/compile_onnx_model.py .
[ ! -f compile_cpu_only_onnx_model.py ] && ln -s ${TVM_ROOT}/tutorials/compile_cpu_only_onnx_model.py .
