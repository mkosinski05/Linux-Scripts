#!/bin/bash

CREATEIMAGEFIlE=create_image.sh
CONFIGFILE=example_config.ini


if [ ! -f ${CREATEIMAGEFIlE} ]; then
	ln -s /home/zkmike/Scripts/rzg2_bsp_scripts/image_creator/create_image.sh .
fi

WORKDIRS=`ls -d */`
echo ${WORKDIRS}
delete=(Scripts/ sd_card_image/)

for del in ${delete[@]}
do
   WORKDIRS=("${WORKDIRS[@]/$del}")
done
echo ${WORKDIRS}

touch ${CONFIGFILE}
for WORKDIR in ${WORKDIRS[@]}
do

	echo "TMP=\"./sd_card_image\"" > ${CONFIGFILE}
	echo "OUTFILE=\${TMP}/${WORKDIR::-1}_card.img" >> ${CONFIGFILE}

	echo "CREATE_BZ2=no" >> ${CONFIGFILE}
	echo "CREATE_GZIP=no" >> ${CONFIGFILE}
	echo "CREATE_ZIP=no" >> ${CONFIGFILE}

	echo "TOTAL_IMAGE_SIZE=2GB" >> ${CONFIGFILE}

	echo "FAT_SIZE=500M" >> ${CONFIGFILE}

	echo "FAT_FILES=${PWD}/${WORKDIR}/build/tmp/deploy/images/smarc-rzv2l" >> ${CONFIGFILE}
	echo "IMG_FILE=Image" >> ${CONFIGFILE}
	echo "DTB_FILE=r9a07g054l2-smarc.dtb" >> ${CONFIGFILE}
	echo "FAT_LABEL=RZ_FAT" >> ${CONFIGFILE}

	echo "EXT_TYPE=ext3" >> ${CONFIGFILE}
	echo "EXT_FILES=${PWD}/${WORKDIR}/build/tmp/deploy/images/smarc-rzv2l" >> ${CONFIGFILE}
	echo "EXT_TAR_FILE=core-image-weston-smarc-rzv2l.tar.gz" >> ${CONFIGFILE}
	echo "EXT_LABEL=RZ_ext" >> ${CONFIGFILE}
	
	./${CREATEIMAGEFIlE} ${CONFIGFILE}
	
done
rm ${CONFIGFILE}
rm ${CREATEIMAGEFIlE}

