#!/bin/bash

# this scripts will do following to launch Linux
#   1. copy your dts to .hw.dts
#   2. update dts with correct image size
#   3. run socinit gdb scripts (which is configure the SOC platfrom)
#   4. run gdbinit gdb scripts (which load linux images and start linux)

if [ $# -lt 1 -o $# -gt 4 ] ; then
	echo "Usage:  run.sh <DebugServer_ip:port>  <soc_platform>"
	echo ""
	echo "<soc_platform>:  Choose one from [ xiaohui | ice_fpga2 | x908 ] etc."
	exit 1
fi

set -e
TARGET_REMOTE=$1
BOARD=$2
SOCINIT=$BOARD.socinit.txt
GDBINIT=$BOARD.gdbinit.txt
DTS=$BOARD.dts.txt

echo "======== launch info ========"
echo "remote  :" $TARGET_REMOTE
echo "platform:" $BOARD
echo "socinit :" $SOCINIT
echo "gdbinit :" $GDBINIT
echo "dts     :" $DTS
echo "==== ==== ==== ==== ==== ===="
if [ ! -f $GDBINIT -o ! -f $SOCINIT -o ! -f $DTS ]; then
		echo "Error: init file ${SOCINIT} or ${GDBINIT} or dts ${DTS} not exist !"
		exit 1
fi

echo ">> generate '.hw.dts'"
cp $DTS .hw.dts

# modify .hw.dts with correct rootfs size
ROOTFS_BASE=`cat .hw.dts | grep initrd-start | awk -F " " '{print $4}' | awk -F ">" '{print $1}'`
ROOTFS_SIZE=`ls -lt ../rootfs.cpio.gz | awk '{print $5}'`
((ROOTFS_END= $ROOTFS_BASE + $ROOTFS_SIZE))
ROOTFS_END=`printf "0x%x" $ROOTFS_END`
sed -i "s/linux,initrd-end = <0x0 .*/linux,initrd-end = <0x0 $ROOTFS_END>;/g" .hw.dts


set -x

# compile device tree file
./dtc -I dts -O dtb .hw.dts > hw.dtb


# SoC related initialization
if [ $BOARD == "eg" -o $BOARD == "eg2" ]; then
./riscv64-elf-gdb -ex "tar remote $TARGET_REMOTE" -x $SOCINIT ddr_init_eg_elf -ex "c" -ex "q" > /dev/null
else
./riscv64-elf-gdb -ex "tar remote $TARGET_REMOTE" -x $SOCINIT -ex "q"
fi


# boot linux with gdbinit
./riscv64-elf-gdb -ex "tar remote $TARGET_REMOTE" -x $GDBINIT -ex "c"
