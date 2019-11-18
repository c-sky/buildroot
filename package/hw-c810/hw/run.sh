if [ $# != 2 ]; then
	echo "Usage: . run.sh <ip:port> <dh7200/fpga>"
	return 0
fi

if [ $2 == 'dh7200' ]; then
	cp dh7200.dts.txt .hw.dts -f
	cp gdbinit.dh7200.txt gdbinit -f
elif [ $2 == 'fpga' ]; then
	cp fpga.dts.txt .hw.dts -f
	cp gdbinit.fpga.txt gdbinit -f
else
	echo "No support"
	return 0
fi

ROOTFS_BASE=`cat .hw.dts | grep initrd-start | awk -F "<" '{print $2}' | awk -F ">" '{print $1}'`
ROOTFS_SIZE=`ls -lt ../rootfs.cpio.gz | awk '{print $5}'`
((ROOTFS_END= $ROOTFS_BASE + $ROOTFS_SIZE))
ROOTFS_END=`printf "0x%x" $ROOTFS_END`
sed -i "s/linux,initrd-end.*/linux,initrd-end = <$ROOTFS_END>;/g" .hw.dts

dtc -I dts -O dtb .hw.dts > hw.dtb

if [ $2 == 'fpga' ]; then
# Init DDR
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x ddrinit.txt ddr_init_elf
fi

# Run linux
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x gdbinit -ex "c" -ex "q"
