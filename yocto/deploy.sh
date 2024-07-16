if [ -z "$1" ]; then
    echo "Enter the SDCard Device path: ie /dev/sdb"
else
    pushd ${PWD}/ai_sdk/build/tmp/deploy/images/rzv2h-evk-ver1
    sudo bmaptool copy --bmap core-image-weston-rzv2h-evk-ver1.wic.bmap core-image-weston-rzv2h-evk-ver1.wic.gz $1
    popd
fi
