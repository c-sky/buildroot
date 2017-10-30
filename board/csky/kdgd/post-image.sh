#!/bin/sh
./board/csky/common/tools/merge_spl_uboot.sh ${BINARIES_DIR}
cp -f ${BUILD_DIR}/linux-*/vmlinux ${BINARIES_DIR}
