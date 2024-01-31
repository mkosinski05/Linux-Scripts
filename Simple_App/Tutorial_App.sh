if [[ $1 == "V2L" ]]; then
ADDR_MAP=0x838E0000
elif [[ $1 == "V2M" ]]; then
ADDR_MAP=0xC38E0000
elif [[ $1 == "V2MA" ]]; then
ADDR_MAP=0x438E0000
else
    echo "Enter V2MA, V2M, or V2L"
    exit
fi

OUTPUT_DIR=/root/RZ${1}/RZV_TVM_Demo
mkdir $OUTPUT_DIR

###############################################################################
# Build Resnet18 for turorial_app
###############################################################################
cd $TVM_ROOT/tutorials
pwd
wget https://github.com/onnx/models/raw/main/vision/classification/resnet/model/resnet18-v1-7.onnx

if [ -d compile_onnx_model_app.py ]; then
rm compile_onnx_model_app.py
fi

sed "s/0x438E0000/${ADDR_MAP}/" compile_onnx_model.py > compile_onnx_model_app.py

echo "###############################################################################"
echo "The Product ${PRODUCT} address map is set to : "
grep addr_map_start compile_onnx_model_app.py
echo "###############################################################################"
python3 compile_onnx_model_app.py \
    ./resnet18-v1-7.onnx \
    -o resnet18_onnx \
    -s 1,3,224,224 \
    -i data

mv resnet18_onnx $OUTPUT_DIR

###############################################################################
# Build Tutorial App
###############################################################################
cd $TVM_ROOT/apps/
pwd
if [ -d $TVM_ROOT/apps/build ]; then
    rm -rfd $TVM_ROOT/apps/build
fi

mkdir $TVM_ROOT/apps/build


cd $TVM_ROOT/apps/build
pwd

cmake -DCMAKE_TOOLCHAIN_FILE=./toolchain/runtime.cmake ..

make -j$(nproc)

# Move/Copy Application Binary and supported files
mv tutorial_app $OUTPUT_DIR
cp $TVM_ROOT/apps/exe/sample.bmp $OUTPUT_DIR
cp $TVM_ROOT/apps/exe/synset_words_imagenet.txt $OUTPUT_DIR

