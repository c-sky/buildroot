#!/bin/bash

BINARIES_DIR=$1

dd if=/dev/zero of=${BINARIES_DIR}/.temp.bin bs=512 count=24
cat ${BINARIES_DIR}/u-boot-spl.bin ${BINARIES_DIR}/.temp.bin >> ${BINARIES_DIR}/.temp_a.bin
dd if=${BINARIES_DIR}/.temp_a.bin of=${BINARIES_DIR}/.temp_b.bin bs=512 count=24
cat ${BINARIES_DIR}/.temp_b.bin ${BINARIES_DIR}/u-boot.bin >> ${BINARIES_DIR}/spl_uboot.bin
rm -f ${BINARIES_DIR}/.temp.bin ${BINARIES_DIR}/.temp_a.bin ${BINARIES_DIR}/.temp_b.bin

