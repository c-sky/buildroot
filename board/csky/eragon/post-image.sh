#!/bin/sh
./board/csky/common/tools/merge_spl_uboot.sh
cp -n board/csky/eragon/.gdbinit ./
