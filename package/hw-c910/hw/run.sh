if [ $# -lt 1 -o $# -gt 3 ] ; then
	echo "Usage: . run.sh <ip:port> [an/eg/ve] [s/m]"
	echo "Usage: [an/eg/ve] is for board name"
	echo "Usage: [s/m] is for onecore/twocore"
	exit 1
fi

BOARD="eg"
NRCORE=2

for idx in "$@"
do
if [ $idx == "an" ]; then
	BOARD="an"
elif [ $idx == "ban" ]; then
	BOARD="ban"
elif [ $idx == "eg" ]; then
	BOARD="eg"
elif [ $idx == "ve" ]; then
	BOARD="ve"
elif [ $idx == "s" ]; then
	NRCORE=1
elif [ $idx == "m" ]; then
	NRCORE=2
fi
case "$idx" in
    [1-9] | [1-1][0-6])
		NRCORE=$idx
esac
done

set -ex

DDRINIT=ddrinit.$BOARD.txt
GDBINIT=gdbinit.$BOARD.txt
DTS=$BOARD.dts.txt

echo "Use config" $NRCORE $BOARD
if [ ! -f $GDBINIT -o ! -f $DTS ]; then
	echo "No support"
	exit 1
fi

enable_dts_cores() {
	let x=$1-1
	for ((i=1;i<=$x;i++)); do
		y=`awk '/cpu@'$i' \{/{getline a;print NR}' .hw.dts`
		let y=$y+2
		sed -i ''$y','$y's/fail/okay/g' .hw.dts
	done
}

cp $DTS .hw.dts
if [ $NRCORE -gt 1 ] ; then
enable_dts_cores $NRCORE
fi

ROOTFS_BASE=`cat .hw.dts | grep initrd-start | awk -F "<" '{print $2}' | awk -F ">" '{print $1}'`
ROOTFS_SIZE=`ls -lt ../rootfs.cpio.gz | awk '{print $5}'`
((ROOTFS_END= $ROOTFS_BASE + $ROOTFS_SIZE))
ROOTFS_END=`printf "0x%x" $ROOTFS_END`
sed -i "s/linux,initrd-end.*/linux,initrd-end = <$ROOTFS_END>;/g" .hw.dts

dtc -I dts -O dtb .hw.dts > hw.dtb

# Init DDR
if [ $BOARD == "ve" ]; then
	echo "No need ddr_init for veloce"
elif [ $BOARD == "eg" ]; then
./riscv64-linux-gdb -ex "tar remote $1" -x $DDRINIT ddr_init_$BOARD\_elf -ex "c" -ex "q" > /dev/null
elif [ $BOARD == "an" ]; then
./riscv64-linux-gdb -ex "tar remote $1" -x $DDRINIT -ex "q"
fi

# Run linux
./riscv64-linux-gdb -ex "tar remote $1" -x $GDBINIT -ex "c" -ex "q"
