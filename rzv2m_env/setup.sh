SRC_DIR=/media/zkmike/0DF83D052A378594/Renesas/RZV/RZV2M/v0102

cp $SRC_DIR/r01an5971ej0120-rzv2m-linux.zip .
cp $SRC_DIR/r11an0530ej0600-rzv2m-drpai-sp.zip .
cp $SRC_DIR/r01an5978ej0120-rzv2m_isp-support.zip .


docker build --no-cache --rm --build-arg "host_uid=$(id -u)" \
--build-arg "ver_bsp=v102" \
--build-arg "user_name=$(whoami)" \
--build-arg "host_gid=$(id -g)" --tag "rzv2m_yocto:1.02" .


rm r01an5971ej0120-rzv2m-linux.zip 
rm r11an0530ej0600-rzv2m-drpai-sp.zip 
rm r01an5978ej0120-rzv2m_isp-support.zip 
