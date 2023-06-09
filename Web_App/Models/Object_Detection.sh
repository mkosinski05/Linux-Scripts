DEVICE=$1
ADDR_MAP=$2
OUTPUT_DIR=$3

cd $TVM_ROOT/how-to/sample_app/docs/object_detection/yolo

###############################################################################
#   Get Yolo Pretrained images
###############################################################################
if [[ ! -f d-tinyyolov2.onnx ]]; then
 
# https://github.com/pjreddie/darknet/tree/master/cfg
wget https://github.com/pjreddie/darknet/raw/master/cfg/yolov3.cfg 
wget https://github.com/pjreddie/darknet/raw/master/cfg/yolov3-tiny.cfg 
wget https://github.com/pjreddie/darknet/raw/master/cfg/yolov2-voc.cfg
wget https://github.com/pjreddie/darknet/raw/master/cfg/yolov2-tiny-voc.cfg

# https://pjreddie.com/media/files
wget https://pjreddie.com/media/files/yolov2-voc.weights
wget https://pjreddie.com/media/files/yolov2-tiny-voc.weights
wget https://pjreddie.com/media/files/yolov3.weights
wget https://pjreddie.com/media/files/yolov3-tiny.weights

###############################################################################
#   Get Yolo Pretrained images
###############################################################################

python3 convert_to_pytorch.py yolov3
python3 convert_to_pytorch.py tinyyolov3
python3 convert_to_pytorch.py yolov2
python3 convert_to_pytorch.py tinyyolov2

python3 convert_to_onnx.py yolov3
python3 convert_to_onnx.py tinyyolov3
python3 convert_to_onnx.py yolov2
python3 convert_to_onnx.py tinyyolov2

fi
###############################################################################
#   Prepare TVM Translator Scripts for DRP trans
###############################################################################
cd $TVM_ROOT/tutorials

sed "s/0x438E0000/${ADDR_MAP}/" compile_onnx_model.py > compile_onnx_yolo.py

sed -i "s/config.shape_in.*/config.shape_in\t= [1, 480, 640, 2]/" compile_onnx_yolo.py 
sed -i "s/config.format_in.*/config.format_in\t= drpai_param.FORMAT.YUYV_422/" compile_onnx_yolo.py 
sed -i "s/config.order_in.*/config.order_in\t= drpai_param.ORDER.HWC/" compile_onnx_yolo.py 
sed -i "s/config.type_in.*/config.type_in\t= drpai_param.TYPE.UINT8/" compile_onnx_yolo.py 

sed -i "s/config.format_out.*/config.format_out   = drpai_param.FORMAT.RGB/" compile_onnx_yolo.py 
sed -i "s/config.order_out.*/config.order_out    = drpai_param.ORDER.CHW/" compile_onnx_yolo.py 
sed -i "s/config.type_out.*/config.type_out     = drpai_param.TYPE.FP32/" compile_onnx_yolo.py 

sed -i "s/mean.*=.*/mean\t= [0.0, 0.0, 0.0]/" compile_onnx_yolo.py 
sed -i "s/stdev.*=.*/stdev\t= [1.0, 1.0, 1.0]/" compile_onnx_yolo.py 

###############################################################################
#   Translate Scripts for DRP 
###############################################################################

python3 compile_onnx_yolo.py \
-i input1 \
-s 1,3,416,416 \
-o yolov3_onnx \
$TVM_ROOT/how-to/sample_app/docs/object_detection/yolo/d-yolov3.onnx 

python3 compile_onnx_yolo.py \
$TVM_ROOT/how-to/sample_app/docs/object_detection/yolo/d-yolov2.onnx \
-i input1 \
-s 1,3,416,416 \
-o yolov2_onnx 

python3 compile_onnx_yolo.py \
$TVM_ROOT/how-to/sample_app/docs/object_detection/yolo/d-tinyyolov3.onnx \
-i input1 \
-s 1,3,416,416 \
-o tinyyolov3_onnx 

python3 compile_onnx_yolo.py \
$TVM_ROOT/how-to/sample_app/docs/object_detection/yolo/d-tinyyolov2.onnx \
-i input1 \
-s 1,3,416,416 \
-o tinyyolov2_onnx


###############################################################################
#   Deploy Models
###############################################################################
[[ -d $OUTPUT_DIR/yolov2_onnx ]] && rm -rfd $OUTPUT_DIR/yolov2_onnx
mv yolov2_onnx $OUTPUT_DIR

[[ -d $OUTPUT_DIR/yolov3_onnx ]] && rm -rfd $OUTPUT_DIR/yolov3_onnx
mv yolov3_onnx $OUTPUT_DIR

[[ -d $OUTPUT_DIR/tinyyolov2_onnx ]] && rm -rfd $OUTPUT_DIR/tinyyolov2_onnx
mv tinyyolov2_onnx $OUTPUT_DIR

[[ -d $OUTPUT_DIR/tinyyolov3_onnx ]] && rm -rfd $OUTPUT_DIR/tinyyolov3_onnx
mv tinyyolov3_onnx $OUTPUT_DIR

