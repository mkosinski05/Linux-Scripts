source ../env_setup.sh

# Setup AI Translator 
[ ! -f run_DRP-AI_translator_V2M.sh ] && ln -s ~/workspace/TVM/drp-ai_translator_release/run_DRP-AI_translator_V2M.sh .
[ ! -f run_DRP-AI_translator_V2L.sh ] && ln -s ~/workspace/TVM/drp-ai_translator_release/run_DRP-AI_translator_V2L.sh .
[ ! -d DRP-AI_translator ] && ln -s ~/workspace/TVM/drp-ai_translator_release/DRP-AI_translator .


# Setup TVM
[ ! -f compile_onnx_model.py ] && ln -s ${TVM_ROOT}/tutorials/compile_onnx_model.py .
[ ! -f compile_cpu_only_onnx_model.py ] && ln -s ${TVM_ROOT}/tutorials/compile_cpu_only_onnx_model.py .
