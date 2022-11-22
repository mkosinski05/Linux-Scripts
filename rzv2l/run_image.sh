docker run -it \
  --name=my_ubuntu_18.04_for_rzg \
  --volume="/home/$USER/workspace/yocto/RZV2L/rzv2l:/home/$USER/yocto" \
  --volume="/media/zkmike/0DF83D052A378594/Renesas/RZV/RZV2L/v300/:/home/$USER" \
  --volume="/home/$USER/workspace/yocto/oss_package:/home/$USER/oss_package" \
  --volume="/home/$USER/workspace/yocto/RZV2L/Scripts:/home/$USER/Scripts" \
  --workdir="/home/$USER" \
  rzv_ubuntu:20.04
