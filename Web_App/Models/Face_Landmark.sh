DEVICE=$1
ADDR_MAP=$2
OUTPUT_DIR=$3

cp get_mpose_model.py $TVM_ROOT/how-to/sample_app/docs/face_landmark_localization
cd $TVM_ROOT/how-to/sample_app/docs/face_landmark_localization

###############################################################################
#   Get MPose Model and Source
###############################################################################

if [[ ! -f deeppose_res50_wflw_256x256-92d0ba7f_20210303.pth ]]; then
    wget https://download.openmmlab.com/mmpose/face/deeppose/deeppose_res50_wflw_256x256-92d0ba7f_20210303.pth
fi

#Dowload MMPose Branch v0.28.1
if [[ ! -d mmpose ]]; then
    git clone https://github.com/open-mmlab/mmpose.git --branch v0.28.1
fi

if [[ ! -d deeppose.pt ]]; then
    python3 get_mpose_model.py
fi

###############################################################################
#   Prepare TVM Translator Scripts for CPU only trans
###############################################################################

sed "s/import.*onnx/import torch/" compile_cpu_only_onnx_model.py > compile_cpu_only_pytorch_model.py

sed -i "s/shape_dict =.*/model = torch.jit.load(model_file)\n    model.eval()/" compile_cpu_only_pytorch_model.py
sed -i "s/onnx_model =.*/input_name = \"input0\"\n    shape_list = [(input_name, opts[\"input_shape\"])]/" compile_cpu_only_pytorch_model.py
sed -i "s/mod, params =.*/mod, params = tvm.relay.frontend.from_pytorch(model, shape_list)/" compile_cpu_only_pytorch_model.py

# Delete lines starting at 4. Compile pre-processing using DRP-AI Pre-processing Runtime
sed -i '/Compile pre-processing using DRP-AI Pre-processing Runtime/,$d' compile_cpu_only_pytorch_model.py

###############################################################################
#   Translate Model for CPU only
###############################################################################

python3 compile_cpu_only_pytorch_model.py \
-s 1,3,256,256 \
-o face_deeppose_cpu \
$TVM_ROOT/how-to/sample_app/docs/face_landmark_localization/deeppose.pt


###############################################################################
#   Prepare TVM Translator Scripts for DRP trans
###############################################################################
cd $TVM_ROOT/tutorials

sed "s/0x438E0000/${ADDR_MAP}/" compile_pytorch_model.py > compile_pytorch_mpose.py

sed -i "s/config.shape_in.*/config.shape_in\t= [1, 480, 640, 2]/" compile_pytorch_mpose.py 
sed -i "s/config.format_in.*/config.format_in\t= drpai_param.FORMAT.YUYV_422/" compile_pytorch_mpose.py 
sed -i "s/config.order_in.*/config.order_in\t= drpai_param.ORDER.HWC/" compile_pytorch_mpose.py 
sed -i "s/config.type_in.*/config.type_in\t= drpai_param.TYPE.UINT8/" compile_pytorch_mpose.py 

sed -i "s/config.format_out.*/config.format_out   = drpai_param.FORMAT.RGB/" compile_pytorch_mpose.py 
sed -i "s/config.order_out.*/config.order_out    = drpai_param.ORDER.CHW/" compile_pytorch_mpose.py 
sed -i "s/config.type_out.*/config.type_out     = drpai_param.TYPE.FP32/" compile_pytorch_mpose.py 

sed -i "s/mean.*=.*/mean\t= [0.485, 0.456, 0.406]/" compile_pytorch_mpose.py 
sed -i "s/stdev.*=.*/stdev\t= [0.229, 0.224, 0.225]/" compile_pytorch_mpose.py 

###############################################################################
#   Translate Scripts for DRP 
###############################################################################

python3 compile_pytorch_mpose.py \
-s 1,3,256,256 \
-o face_deeppose_pt \
$TVM_ROOT/how-to/sample_app/docs/face_landmark_localization/deeppose.pt

###############################################################################
#   Deploy Models
###############################################################################

[[ -d $OUTPUT_DIR/face_deeppose_pt ]] && rm -rfd $OUTPUT_DIR/face_deeppose_pt
mv face_deeppose_pt $OUTPUT_DIR

[[ -d $OUTPUT_DIR/face_deeppose_cpu ]] && rm -rfd $OUTPUT_DIR/face_deeppose_cpu
mv face_deeppose_cpu $OUTPUT_DIR
