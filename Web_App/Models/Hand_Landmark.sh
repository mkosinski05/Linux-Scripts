DEVICE=$1
ADDR_MAP=$2
OUTPUT_DIR=$3

cp get_hrnetv2.py $TVM_ROOT/how-to/sample_app/docs/hand_landmark_localization
cd  $TVM_ROOT/how-to/sample_app/docs/hand_landmark_localization

###############################################################################
#   Get MPose Model and Source
###############################################################################

git clone -b v0.28.1 https://github.com/open-mmlab/mmpose.git
if [[ !-f hrnetv2_w18_coco_wholebody_hand_256x256-1c028db7_20210908.pth ]]; then
    wget https://download.openmmlab.com/mmpose/hand/hrnetv2/hrnetv2_w18_coco_wholebody_hand_256x256-1c028db7_20210908.pth
    #wget https://github.com/open-mmlab/mmpose/blob/v0.28.1/configs/hand/2d_kpt_sview_rgb_img/topdown_heatmap/coco_wholebody_hand/hrnetv2_w18_coco_wholebody_hand_256x256.py
fi

if [[ ! -f hrnetv2.pt ]]; then
    python3 get_hrnetv2.py
fi

###############################################################################
#   Prepare TVM Translator Scripts for DRP trans
###############################################################################
cd $TVM_ROOT/tutorials

sed "s/0x438E0000/${ADDR_MAP}/" compile_pytorch_model.py > compile_pytorch_hrnetv2.py

sed -i "s/config.shape_in.*/config.shape_in\t= [1, 480, 640, 2]/" compile_pytorch_hrnetv2.py 
sed -i "s/config.format_in.*/config.format_in\t= drpai_param.FORMAT.YUYV_422/" compile_pytorch_hrnetv2.py 
sed -i "s/config.order_in.*/config.order_in\t= drpai_param.ORDER.HWC/" compile_pytorch_hrnetv2.py 
sed -i "s/config.type_in.*/config.type_in\t= drpai_param.TYPE.UINT8/" compile_pytorch_hrnetv2.py 

sed -i "s/config.format_out.*/config.format_out   = drpai_param.FORMAT.RGB/" compile_pytorch_hrnetv2.py 
sed -i "s/config.order_out.*/config.order_out    = drpai_param.ORDER.CHW/" compile_pytorch_hrnetv2.py 
sed -i "s/config.type_out.*/config.type_out     = drpai_param.TYPE.FP32/" compile_pytorch_hrnetv2.py 

sed -i "s/mean.*=.*/mean\t= [0.485, 0.456, 0.406]/" compile_pytorch_hrnetv2.py 
sed -i "s/stdev.*=.*/stdev\t= [0.229, 0.224, 0.225]/" compile_pytorch_hrnetv2.py 

sed -i "s/config.ops =.*/config.ops = [\n        op.Crop(80, 0, 480, 480),/" compile_pytorch_hrnetv2.py


###############################################################################
#   Translate Model for DRP
###############################################################################

# Run DRP-AI TVM[*1] Compiler script
python3 compile_pytorch_hrnetv2.py \
    $TVM_ROOT/how-to/sample_app/docs/hand_landmark_localization/hrnetv2.pt \
    -o hrnetv2_pt \
    -s 1,3,256,256
    
###############################################################################
#   Deploy Models
###############################################################################

[[ -d $OUTPUT_DIR/hrnetv2_pt ]] && rm -rfd $OUTPUT_DIR/hrnetv2_pt
mv hrnetv2_pt $OUTPUT_DIR

