DEVICE=$1
ADDR_MAP=$2
OUTPUT_DIR=$3


cd $TVM_ROOT/how-to/sample_app/docs/emotion_recognition/emotion_ferplus

###############################################################################
#   Get ONNX File 
###############################################################################
if [[ ! -f emotion-ferplus-8.onnx ]]; then
    wget https://github.com/onnx/models/raw/main/vision/body_analysis/emotion_ferplus/model/emotion-ferplus-8.onnx
fi

###############################################################################
#   Prepare TVM Translator Scripts for DRP trans
###############################################################################

cd $TVM_ROOT/tutorials

sed "s/0x438E0000/${ADDR_MAP}/" compile_onnx_model.py > compile_onnx_emotion.py

sed -i "s/config.shape_in.*/config.shape_in\t= [1, 480, 640, 2]/" compile_onnx_emotion.py 
sed -i "s/config.format_in.*/config.format_in\t= drpai_param.FORMAT.YUYV_422/" compile_onnx_emotion.py 
sed -i "s/config.order_in.*/config.order_in\t= drpai_param.ORDER.HWC/" compile_onnx_emotion.py 
sed -i "s/config.type_in.*/config.type_in\t= drpai_param.TYPE.UINT8/" compile_onnx_emotion.py 

sed -i "s/config.format_out.*/config.format_out   = drpai_param.FORMAT.GRAY/" compile_onnx_emotion.py 
sed -i "s/config.order_out.*/config.order_out    = drpai_param.ORDER.CHW/" compile_onnx_emotion.py 
sed -i "s/config.type_out.*/config.type_out     = drpai_param.TYPE.FP32/" compile_onnx_emotion.py 

sed -i "s/mean.*=.*//" compile_onnx_emotion.py 
sed -i "s/stdev.*=.*//" compile_onnx_emotion.py 
sed -i "s/r = 255//" compile_onnx_emotion.py 
sed -i "s/cof_add.*=.*//" compile_onnx_emotion.py 
sed -i "s/cof_mul.*=.*//" compile_onnx_emotion.py 
sed -i "s/op.Normalize.*//" compile_onnx_emotion.py

sed -i "s/config.ops =.*/config.ops = \[\n        op.Crop(0, 0, config.shape_in[2], config.shape_in[1]),/" compile_onnx_emotion.py

###############################################################################
#   Translate Model for DRP
###############################################################################

python3 compile_onnx_emotion.py \
-i Input3 \
-s 1,1,64,64 \
-o emotion_fp_onnx \
$TVM_ROOT/how-to/sample_app/docs/emotion_recognition/emotion_ferplus/emotion-ferplus-8.onnx

###############################################################################
#   Deploy Models
###############################################################################

[[ -d $OUTPUT_DIR/emotion_fp_onnx ]] && rm -rfd $OUTPUT_DIR/emotion_fp_onnx
mv emotion_fp_onnx $OUTPUT_DIR

