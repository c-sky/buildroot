if [ $# -lt 1 -o $# -gt 4 ] ; then
        echo "Usage: . run.sh <ip:port> [an/eg] [s/m] [30/60]"
        echo "Usage: [an/eg] is the board name"
        echo "Usage: [s/m] is the number of cpu"
        exit 0
fi

BOARD="eg"
NRCORE="twocore"
FREQ="60"

for idx in "$@"
do
        if [ $idx == "an" ]; then
                BOARD="an"
		NRCORE="onecore"
        elif [ $idx == "eg" ]; then
                BOARD="eg"
        elif [ $idx == "s" ]; then
                NRCORE="onecore"
        elif [ $idx == "m" ]; then
                NRCORE="twocore"
        elif [ $idx == "30" ]; then
                FREQ="30"
        elif [ $idx == "60" ]; then
                FREQ="60"
        fi
done

DDRINIT=ddrinit.$BOARD.txt
GDBINIT=gdbinit.$BOARD.txt
DTS=$NRCORE\_$BOARD\_$FREQ\M.dts.txt
echo "Use config" $NRCORE $BOARD $FREQ
if [ ! -f $GDBINIT -o ! -f $DDRINIT -o ! -f $DTS ]; then
	echo "No support"
	exit 1
fi

cp $DTS .c960_lite.dts

ROOTFS_BASE=`cat .c960_lite.dts | grep initrd-start | awk -F "<" '{print $2}' | awk -F ">" '{print $1}'`
ROOTFS_SIZE=`ls -lt ../rootfs.cpio.gz | awk '{print $5}'`
((ROOTFS_END= $ROOTFS_BASE + $ROOTFS_SIZE))
ROOTFS_END=`printf "0x%x" $ROOTFS_END`
sed -i "s/linux,initrd-end.*/linux,initrd-end = <$ROOTFS_END>;/g" .c960_lite.dts

dtc -I dts -O dtb .c960_lite.dts > c960_lite.dtb

# Init DDR
./riscv64-linux-gdb -ex "tar remote $1" -x $DDRINIT ddr_init_$BOARD\_elf -ex "c" -ex "q"

# Run linux
./riscv64-linux-gdb -ex "tar remote $1" -x $GDBINIT -ex "c" -ex "q"
