#!/bin/bash

CREATEIMAGEFIlE=create_image.sh
CONFIGFILE=example_config.ini
KERNELFILE=Image
DTBFILE=r9a09g055ma3gbg-evaluation-board.dtb
FILESYSTEM=core-image-bsp-rzv2ma-20230404051032.rootfs.tar.gz
SDKSCRIPT=poky-glibc-x86_64-core-image-bsp-aarch64-rzv2ma-toolchain-3.1.14.sh

DEPLOYDIR=build/tmp/deploy/images/
SDKDIR=build/tmp/deploy/sdk
IMAGENAME=rzv2ma

FAT_DIR=fat16
EXT_DIR=ext
BOOT_DIR=boot
TMP_DIR=sd_card_image

#Bootloader files
BOOT_FILES=("loader_1st_128kb.bin" "loader_2nd.bin" "loader_2nd_param.bin" "u-boot.bin" "u-boot_param.bin")

echo "Do You want to deply SDCard Images? (yes/no)"
read question
if [[ "yes" == ${question} ]]; then


if [ ! -f ${CREATEIMAGEFIlE} ]; then
	ln -s /home/zkmike/Scripts/rzg2_bsp_scripts/image_creator/create_image.sh .
fi

WORKDIRS=`ls -d */`

delete=(Scripts/ sd_card_image/ sdk/)

for del in ${delete[@]}
do
   WORKDIRS=("${WORKDIRS[@]/$del}")
done
echo ${WORKDIRS}

touch ${CONFIGFILE}
for WORKDIR in ${WORKDIRS[@]}
do

	echo "Do You want to deply ${WORKDIR} SDCard Images? (yes/no)"
	read question
	if [[ "no" == ${question} ]]; then
		continue
	fi
	
	echo "------------------------------------------------------------------"
	echo "          				${WORKDIR}"
	echo "------------------------------------------------------------------"
	
	# Check that the kernel, dtb, and filesystem files exists
	pushd ${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}
	pwd
	
	if [ ! -f ${KERNELFILE} ] ; then
		echo " Kernel Image file: (${KERNELFILE}) does not exit in"
		echo "${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}"
		popd
		continue
	fi
	if [ ! -f ${DTBFILE} ] ; then
		echo " DTB Image file: (${DTBFILE}) does not exit in"
		echo "${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}"
		popd
		continue
	fi
	if [ ! -f ${FILESYSTEM} ] ; then
		echo " Linux File System Image file: (${FILESYSTEM}) does not exit in"
		echo "${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}"
		popd
		continue
	fi
	popd
	
	# Copy and extract files to temporay 
	if [ ! -d ${TMP_DIR} ] ; then
		mkdir ${TMP_DIR}
	fi
	
	if [ ! -d ${PWD}/${TMP_DIR}/${FAT_DIR} ] ; then
		rm -rfd  ${PWD}/${TMP_DIR}/${FAT_DIR}
		mkdir ${PWD}/${TMP_DIR}/${FAT_DIR}
	fi
	
	if [ ! -d ${PWD}/${TMP_DIR}/${EXT_DIR} ] ; then
		rm -rfd ${PWD}/${TMP_DIR}/${EXT_DIR}
		mkdir ${PWD}/${TMP_DIR}/${EXT_DIR}
	fi
	
	# Copy and extract files to temporay 
	cp ${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}/${KERNELFILE} ${PWD}/${TMP_DIR}/${FAT_DIR}
	cp ${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}/${DTBFILE} ${PWD}/${TMP_DIR}/${FAT_DIR}
	
	echo "tar -xvf ${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}/${FILESYSTEM} ${PWD}/${TMP_DIR}/${EXT_DIR}"
	tar -xvf ${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}/${FILESYSTEM} -C ${PWD}/${TMP_DIR}/${EXT_DIR}
	
	# Create Image Creator file
	echo "TMP=${TMP_DIR}" > ${CONFIGFILE}
	echo "OUTFILE=${TMP_DIR}/${WORKDIR::-1}_card.img" >> ${CONFIGFILE}

	echo "CREATE_BZ2=no" >> ${CONFIGFILE}
	echo "CREATE_GZIP=no" >> ${CONFIGFILE}
	echo "CREATE_ZIP=no" >> ${CONFIGFILE}

	echo "TOTAL_IMAGE_SIZE=2GB" >> ${CONFIGFILE}

	echo "FAT_SIZE=500M" >> ${CONFIGFILE}
	
	
	echo "FAT_FILES=${PWD}/${TMP_DIR}/${FAT_DIR}" >> ${CONFIGFILE}
	echo "FAT_LABEL=RZ_FAT" >> ${CONFIGFILE}

	echo "EXT_TYPE=ext3" >> ${CONFIGFILE}
	echo "EXT_FILES=${PWD}/${TMP_DIR}/${EXT_DIR}" >> ${CONFIGFILE}
	echo "EXT_LABEL=RZ_ext" >> ${CONFIGFILE}
	
	./${CREATEIMAGEFIlE} ${CONFIGFILE}
	
	echo "------------------------------------------------------------------"
	echo "          				Create SDCard"
	echo "------------------------------------------------------------------"
	# Copy the uboot loader files to temp dir
	if [ ! -d ${PWD}/${TMP_DIR}/${BOOT_DIR} ] ; then
		rm -rfd  ${PWD}/${TMP_DIR}/${BOOT_DIR}
		mkdir ${PWD}/${TMP_DIR}/${BOOT_DIR}
	fi
	
	for BOOT in ${BOOT_FILES[@]}; do
		cp ${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}/${BOOT} ${PWD}/${TMP_DIR}/${BOOT_DIR}
	done
	unzip -j /media/zkmike/RZ/RZV2MA/r01an6514ej0111-rzv2ma-linux.zip r01an6514ej0111-rzv2ma-linux/option/flash_writer/B2_intSW.bin -d ${PWD}/${TMP_DIR}/${BOOT_DIR}
	
	# Compress SDCard image, bootloader files, Image Writer, and SDK files into the archive file
	zip -j ${WORKDIR::-1}_sdcard.zip ${PWD}/${TMP_DIR}/${BOOT_DIR}/*  ${TMP_DIR}/${WORKDIR::-1}_card.img ${PWD}/${WORKDIR}/${SDKDIR}/*.sh

	
done
rm ${CONFIGFILE}
rm ${CREATEIMAGEFIlE}
#rm -rfd ${TMP_DIR}
fi

echo "------------------------------------------------------------------"
echo "          				Deply SDKs"
echo "------------------------------------------------------------------"
echo "Do You want to deply SDK? (yes/no)"
read question
if [[ "no" == ${question} ]]; then
	exit
fi

sudo rm -rfd /opt/poky 

WORKDIRS=`ls -d */`

delete=(Scripts/ sd_card_image/)

for del in ${delete[@]}
do
   WORKDIRS=("${WORKDIRS[@]/$del}")
done

for WORKDIR in ${WORKDIRS}
do
	pushd ${PWD}/${WORKDIR}${SDKDIR}
	echo $WORKDIR
	sh ${SDKSCRIPT}
	popd
done



