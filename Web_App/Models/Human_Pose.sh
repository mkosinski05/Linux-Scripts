DEVICE=$1
ADDR_MAP=$2
OUTPUT_DIR=$3


cd $TVM_ROOT/how-to/sample_app/docs/classification/googlenet

###############################################################################
#   Get ONNX File 
###############################################################################

if [[ ! -f googlenet-9.onnx ]]; then
    wget https://github.com/onnx/models/raw/main/vision/classification/inception_and_googlenet/googlenet/model/googlenet-9.onnx
fi
###############################################################################
#   Prepare TVM Translator Scripts for DRP trans
###############################################################################

cd $TVM_ROOT/tutorials

sed "s/0x438E0000/${ADDR_MAP}/" compile_onnx_model.py > compile_onnx_pose.py

sed -i "s/config.shape_in.*/config.shape_in\t= [1, 480, 640, 2]/" compile_onnx_pose.py 
sed -i "s/config.format_in.*/config.format_in\t= drpai_param.FORMAT.YUYV_422/" compile_onnx_pose.py 
sed -i "s/config.order_in.*/config.order_in\t= drpai_param.ORDER.HWC/" compile_onnx_pose.py 
sed -i "s/config.type_in.*/config.type_in\t= drpai_param.TYPE.UINT8/" compile_onnx_pose.py 

sed -i "s/config.format_out.*/config.format_out   = drpai_param.FORMAT.RGB/" compile_onnx_pose.py 
sed -i "s/config.order_out.*/config.order_out    = drpai_param.ORDER.CHW/" compile_onnx_pose.py 
sed -i "s/config.type_out.*/config.type_out     = drpai_param.TYPE.FP32/" compile_onnx_pose.py 

sed -i "s/mean.*=.*/mean\t= [0.485, 0.456, 0.406]/" compile_onnx_pose.py 
sed -i "s/stdev.*=.*/stdev   = [0.229, 0.224, 0.225]/" compile_onnx_pose.py 
sed -i "s/config.ops = \[/config.ops = \[\n        op.Crop(184, 0, 270, 480),/" compile_onnx_pose.py

###############################################################################
#   Translate Model for DRP
###############################################################################

python3 compile_onnx_pose.py \
-i input.1 \
-s 1,3,256,192 \
-o hrnet_onnx \
$TVM_ROOT/how-to/sample_app/docs/classification/googlenet/googlenet-9.onnx

###############################################################################
#   Deploy Models
###############################################################################

[[ -d $OUTPUT_DIR/hrnet_onnx ]] && rm -rfd $OUTPUT_DIR/hrnet_onnx
mv hrnet_onnx $OUTPUT_DIR

