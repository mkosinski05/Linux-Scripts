
if [ $( docker ps -a | grep testContainer | wc -l ) -gt 0 ]; then
  echo "testContainer exists"
  docker rm -f rz_network_boot
fi

docker run -it \
  --name=rz_network_boot \
  --volume="/home/$USER/nfs:/nfs" \
  --volume="/home/$USER/tftboot:/tftboot" \
  --workdir="/home/$USER" \
  --privileged \
  --network host \
  --user root \
  rzv_netboot:1.00
  
docker start -ait rz_network_boot
