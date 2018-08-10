#!/bin/sh
./board/csky/common/tools/merge_spl_uboot.sh
./board/csky/common/tools/make_media_image.sh
if [ ! -L ./ddr_init ]; then
	ln -sf ${BASE_DIR}/build/linux-*/addons/ddr_init/eragon2 ./ddr_init
fi
