
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
DUM=0

pip3 install mmcv-full==1.6.1
pip3 install mmpose==0.28.1

OUTPUT_DIR=/root/RZ${1}/RZV_TVM_WebDemo
[[ -d $OUTPUT_DIR ]] && rm -rfd $OUTPUT_DIR
mkdir $OUTPUT_DIR

cd /root/Scripts/Web_App

###############################################################################
#   Translate TVM Models
###############################################################################
cd Models
./Classification.sh $1 $ADDR_MAP $OUTPUT_DIR
./Emotion_Recognition.sh $1 $ADDR_MAP $OUTPUT_DIR
./Face_Detection.sh $1 $ADDR_MAP $OUTPUT_DIR
#./Face_Landmark.sh $1 $ADDR_MAP $OUTPUT_DIR
#./Hand_Landmark.sh $1 $ADDR_MAP $OUTPUT_DIR
./Human_Pose.sh $1 $ADDR_MAP $OUTPUT_DIR
#./Object_Detection.sh $1 $ADDR_MAP $OUTPUT_DIR

###############################################################################
#   Build Web Application
###############################################################################
if [[ DUM -eq 1 ]]; then
cd $TVM_ROOT/how-to/sample_app/src

if [ -d $TVM_ROOT/how-to/sample_app/src/build ]; then
    rm -rfd $TVM_ROOT/how-to/sample_app/src/build
fi

mkdir $TVM_ROOT/how-to/sample_app/src/build


cd $TVM_ROOT/how-to/sample_app/src/build
pwd

cmake -DCMAKE_TOOLCHAIN_FILE=./toolchain/runtime.cmake ..

make -j$(nproc)

mv sample_app_drpai_tvm_usbcam_http $OUTPUT_DIR
cp $TVM_ROOT/how-to/sample_app/exe/coco-labels-2014_2017.txt $OUTPUT_DIR
cp $TVM_ROOT/how-to/sample_app/exe/synset_words_imagenet.txt $OUTPUT_DIR
fi
