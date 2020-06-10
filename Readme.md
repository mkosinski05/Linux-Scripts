
Build the Image
docker build --no-cache --build-arg "host_uid=$(id -u)" \
 --build-arg "user_name=$(whoami)"\
 --build-arg "host_gid=$(id -g)" --tag "rzg2e_yocto:1.0" .

RUn the image
docker run -it --rm -v $PWD/input:/home/cuteradio/yocto/input rzg2e_yocto:1.0
  
Cleanup
  Remove all stopoed Containers
  docker rm $(docker ps -a -q)
  
  Remove all imgaes created after Ubuntu 16.04
  docker image rm $(docker images --filter 'since=ubuntu:16.04')
  
