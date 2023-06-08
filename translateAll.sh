WORKDIR=/home/zkmike/workspace/TVM
ai_trans_log="ai_trans.log"
cd $WORKDIR/UserConfig/prepost
config_files=`find -name "*.yaml"`
cd $WORKDIR

if test -f $ai_trans_log; then
	rm $ai_trans_log
fi

if test -d "output"; then
	rm -rfd output
fi

for file in $config_files; do
	
	prepost="UserConfig/prepost/${file:2}"

	addr="UserConfig/addr/addrmap.yaml"
	
	prefix=${file:10:-5}
	if [[ $prefix == "d-"* ]]; then
		prefix="${prefix:2}_bmp"
		onnx="onnx/${file:12:-5}.onnx"
	elif [[ $prefix == "c-"* ]]; then
		prefix="${prefix:2}_cam"
		onnx="onnx/${file:12:-5}.onnx"
	else
		onnx="onnx/${file:10:-5}.onnx"
	fi

	echo "./run_DRP-AI_translator_V2L.sh $prefix -onnx $onnx -prepost $prepost -addr $addr" >> $ai_trans_log
	./run_DRP-AI_translator_V2L.sh $prefix -onnx $onnx -prepost $prepost -addr $addr
done
