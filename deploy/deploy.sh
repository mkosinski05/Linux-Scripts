#!/bin/bash

CREATEIMAGEFIlE=create_image.sh
CONFIGFILE=example_config.ini
KERNELFILE=Image
DTBFILE=r9a07g054l2-smarc.dtb
FILESYSTEM=core-image-weston-smarc-rzv2l.tar.gz
SDKSCRIPT=poky-glibc-x86_64-core-image-weston-aarch64-smarc-rzv2l-toolchain-3.1.17.sh

DEPLOYDIR=build/tmp/deploy/images/
SDKDIR=build/tmp/deploy/sdk
IMAGENAME=smarc-rzv2l

FAT_DIR=fat16
EXT_DIR=ext
BOOT_DIR=boot
TMP_DIR=sd_card_image

#Bootloader files
BOOT_FILES=("bl2_bp-smarc-rzv2l_pmic.srec" "fip-smarc-rzv2l_pmic.srec" "Flash_Writer_SCIF_RZV2L_SMARC_PMIC_DDR4_2GB_1PCS.mot")

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

	# Change the configuration based on Renesas or Avnet Board
	echo "Is this a AVNET or Renesas Board ( AVNET = 1, Renesas = 2"
	read BoardType
	
	if [[ "${BoardType}" == 1 ]]; then
		IMAGENAME=rzboard
		DTBFILE=rzboard.dtb
		FILESYSTEM=avnet-core-image-rzboard.tar.gz
	else
		IMAGENAME=smarc-rzv2l
		DTBFILE=r9a07g054l2-smarc.dtb
		FILESYSTEM=core-image-weston-smarc-rzv2l.tar.gz
	fi
	
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
		mkdir d ${TMP_DIR}
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
	
	# Compress SDCard image, bootloader files, Image Writer, and SDK files into the archive file
	echo zip -j ${WORKDIR::-1}_sdcard.zip ${PWD}/${TMP_DIR}/${BOOT_DIR}/*  ${TMP_DIR}/${WORKDIR::-1}_card.img ${PWD}/${WORKDIR}/${SDKDIR}/*.sh
	zip -j ${WORKDIR::-1}_sdcard.zip ${PWD}/${TMP_DIR}/${BOOT_DIR}/*  ${TMP_DIR}/${WORKDIR::-1}_card.img ${PWD}/${WORKDIR}/${SDKDIR}/*.sh

	
done
rm ${CONFIGFILE}
rm ${CREATEIMAGEFIlE}
rm -rfd ${TMP_DIR}
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



