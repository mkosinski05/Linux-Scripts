#!/bin/bash

deploy () {
	# Check Network Directory exists
	if [ ! -d $TFTDIR ]; then
		echo " TFT Directory does not exit ${TFTDIR}"
		sudo mkdir $TFTDIR
		sudo chmod 777 $TFTDIR
	fi

	if [ ! -d $NFSDIR ]; then
		echo " NFS Directory does not exit ${NTFSDIR}"
		sudo mkdir $NTFSDIR -p
		sudo echo -e "${NFSDIR} *(rw,no_subtree_check,sync,no_root_squash)" >> /etc/exports
		sudo exportfs -a
		showmount -e localhost
	fi

	# Deploy to TFTBoot
	sudo cp -v Image $TFTDIR
	sudo cp -v r9a07g054l2-smarc.dtb $TFTDIR

	# Deploy Filesystem to NTFS
	sudo tar -xvf core-image-weston-smarc-rzv2l.tar.gz -C $NTFSDIR
}

###############################################################################
#		Main
###############################################################################

if [ $# -gt 0 ]; then
	# Change to the Yocto output directory that contains the files
	cd $1

	TFTDIR=/tftpboot/${1}
	NTFSDIR=/nfs/${1}

	echo $TFTDIR
	echo $NTFSDIR

	cd build/tmp/deploy/images/smarc-rzv2l
	
	deploy
else
	echo "Please enter the buiild directory name"
fi


