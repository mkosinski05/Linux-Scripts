#!/bin/bash

CREATEIMAGEFIlE=create_image.sh
CONFIGFILE=example_config.ini
KERNELFILE=Image
DTBFILE=r9a07g054l2-smarc.dtb
FILESYSTEM=core-image-weston-smarc-rzv2l.tar.gz

DEPLOYDIR=build/tmp/deploy/images/
IMAGENAME=smarc-rzv2l

if [ ! -f ${CREATEIMAGEFIlE} ]; then
	ln -s /home/zkmike/Scripts/rzg2_bsp_scripts/image_creator/create_image.sh .
fi

WORKDIRS=`ls -d */`

delete=(Scripts/ sd_card_image/)

for del in ${delete[@]}
do
   WORKDIRS=("${WORKDIRS[@]/$del}")
done
echo ${WORKDIRS}

touch ${CONFIGFILE}
for WORKDIR in ${WORKDIRS[@]}
do

	echo "------------------------------------------------------------------"
	echo "          				${WORKDIR}"
	echo "------------------------------------------------------------------"

	if [[ "${WORKDIR::-1}" == *"avnet"* ]] || [[ "${WORKDIR::-1}" == *"rzboard"* ]]; then
		IMAGENAME=rzboard
		DTBFILE=rzboard.dtb
		FILESYSTEM=avnet-core-image-rzboard.tar.gz
	else
		IMAGENAME=smarc-rzv2l
		DTBFILE=r9a07g054l2-smarc.dtb
		FILESYSTEM=core-image-weston-smarc-rzv2l.tar.gz
	fi
	
	pwd
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
	
	echo "TMP=\"./sd_card_image\"" > ${CONFIGFILE}
	echo "OUTFILE=\${TMP}/${WORKDIR::-1}_card.img" >> ${CONFIGFILE}

	echo "CREATE_BZ2=no" >> ${CONFIGFILE}
	echo "CREATE_GZIP=no" >> ${CONFIGFILE}
	echo "CREATE_ZIP=no" >> ${CONFIGFILE}

	echo "TOTAL_IMAGE_SIZE=2GB" >> ${CONFIGFILE}

	echo "FAT_SIZE=500M" >> ${CONFIGFILE}
	
	
	echo "FAT_FILES=${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}" >> ${CONFIGFILE}
	echo "IMG_FILE=Image" >> ${CONFIGFILE}
	echo "DTB_FILE=r9a07g054l2-smarc.dtb" >> ${CONFIGFILE}
	echo "FAT_LABEL=RZ_FAT" >> ${CONFIGFILE}

	echo "EXT_TYPE=ext3" >> ${CONFIGFILE}
	echo "EXT_FILES=${PWD}/${WORKDIR}${DEPLOYDIR}${IMAGENAME}" >> ${CONFIGFILE}
	echo "EXT_TAR_FILE=core-image-weston-smarc-rzv2l.tar.gz" >> ${CONFIGFILE}
	echo "EXT_LABEL=RZ_ext" >> ${CONFIGFILE}
	
	./${CREATEIMAGEFIlE} ${CONFIGFILE}
	
done
rm ${CONFIGFILE}
rm ${CREATEIMAGEFIlE}

