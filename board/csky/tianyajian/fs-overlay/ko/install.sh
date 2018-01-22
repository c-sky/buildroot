#!/bin/sh
#
# Copy ko to the rootfs
#
# Usage: Set "KSC_ROOT" and "MODULES_DIR" to the directories of
#        your own before running this script
#
# Author		Date            Comments
# XuHang		2015-07-22      First created
#


# Directory of sllib source tree
KSC_ROOT=~/xh/ivs/kernel/drivers/char/ksysctl
# Directory of rootfs
MODULES_DIR=~/xh/ivs/rootfs/lib/modules/3.0.8+

# Copy to rootfs
cp ${KSC_ROOT}/ko/insmod.sh	${MODULES_DIR}/
cp ${KSC_ROOT}/ko/rmmod.sh	${MODULES_DIR}/
cp ${KSC_ROOT}/common/slcommon.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/core/slksysctl.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/memorydev/slmemorydev.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/dma/sldma.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/mpu/slmpu.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/vpu/slvpu.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/fdip/slfdip.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/vtkdsp/slvtkdsp.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/vpre2venc/slvpre2venc.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/graphic/slgraphic.ko	${MODULES_DIR}/
cp ${KSC_ROOT}/modules/nulldev/slnulldev.ko	${MODULES_DIR}/

