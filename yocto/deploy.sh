YOCTO_BUILD=$PWD/rzv2l
OUTPUT_DIR=/home/zkmike/Images/v3.05_update

mkdir ${OUTPUT_DIR}
mkdir ${OUTPUT_DIR}/boot

cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/Image $OUTPUT_DIR
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/r9a07g054l2-smarc.dtb $OUTPUT_DIR
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/core-image-weston-smarc-rzv2l.tar.gz $OUTPUT_DIR

cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/core-image-weston-smarc-rzv2l.wic.bmap $OUTPUT_DIR
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/core-image-weston-smarc-rzv2l.wic.gz $OUTPUT_DIR

cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/Flash_Writer_SCIF_RZV2L_SMARC_DDR4_4GB.mot $OUTPUT_DIR/boot
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/Flash_Writer_SCIF_RZV2L_SMARC_PMIC_DDR4_2GB_1PCS.mot $OUTPUT_DIR/boot
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/fip-smarc-rzv2l_pmic.srec $OUTPUT_DIR/boot
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/fip-smarc-rzv2l.srec $OUTPUT_DIR/boot
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/bl2_bp-smarc-rzv2l_pmic.srec $OUTPUT_DIR/boot
cp ${YOCTO_BUILD}/build/tmp/deploy/images/smarc-rzv2l/bl2_bp-smarc-rzv2l.srec $OUTPUT_DIR/boot

cp ${YOCTO_BUILD}/build/tmp/deploy/sdk/poky-glibc-x86_64-core-image-weston-aarch64-smarc-rzv2l-toolchain-3.1.26.sh $OUTPUT_DIR

sync

