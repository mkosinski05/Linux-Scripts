# Change to the Yocto output directory that contains the files
cd rzv2l_bsp_v0.8/build/tmp/deploy/images/smarc-rzv2l

# Copy the Linux kernel and Device Tree to partition 1
sudo cp -v Image /media/$USER/RZ_FAT
sudo cp -v r9a07g054l2-smarc.dtb /media/$USER/RZ_FAT

# Copy and expand the Root File System to partition 2
sudo tar -xvf core-image-weston-smarc-rzv2l.tar.gz   -C /media/$USER/RZ_ext

# Make sure all files are finished writing before removing the USB card reader from the PC
sync
    
