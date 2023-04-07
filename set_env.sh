conda activate tvm
cd ~/workspace/TVM
export TVM_DEV=/home/zkmike/workspace/TVM
export TVM_ROOT=/home/zkmike/workspace/TVM/drp-ai_tvm
export TVM_HOME=${TVM_ROOT}/tvm                # Your own path to the cloned repository.
export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}
                                                  # Your own RZ/V2MA Linux SDK path.
export TRANSLATOR=${TVM_DEV}/drp-ai_translator_release   # Your own DRP-AI Translator path.
export PRODUCT=V2L

echo "Which SDK should be used ?"
ls /opt/poky

read sdkname
export SDK=/opt/poky/${sdkname}


echo "TVM_DEV  : " ${TVM_DEV}
echo "TVM_HOME : " $TVM_HOME
echo "TVM_ROOT : " $TVM_ROOT
echo "PYTHONPATH : " $PYTHONPATH
echo "TRANSLATOR : " $TRANSLATOR
echo "PRODUCT	: " $PRODUCT
echo "SDK : " $SDK


