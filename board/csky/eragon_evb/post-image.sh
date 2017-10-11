#!/bin/sh
./board/csky/common/tools/merge_spl_uboot.sh
./board/csky/common/tools/make_media_image.sh
cp -n board/csky/eragon_evb/.gdbinit ./
