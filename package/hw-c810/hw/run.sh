if [ $# != 2 ]; then
	echo "Usage: . run.sh <ip:port> <dh7200/fpga>"
	return 0
fi

cd ..
rm rootfs.cpio
gzip -d rootfs.cpio.gz
rm rootfs -rf
mkdir -p rootfs
cd rootfs
cpio -idm < ../rootfs.cpio
rm -f etc/init.d/S40network
rm -f etc/init.d/S50sshd
rm ../rootfs.cpio
find . | cpio --quiet -o -H newc > ../rootfs.cpio
cd ..
gzip -c -9 rootfs.cpio >rootfs.cpio.gz
cd hw
ROOTFS_BASE=`cat $2.dts.txt |grep initrd-start|awk -F "<" '{print $2}'|awk -F ">" '{print $1}'`
ROOTFS_SIZE=`ls -lt ../rootfs.cpio.gz|awk '{print $5}'`
((ROOTFS_END= $ROOTFS_BASE + $ROOTFS_SIZE))
ROOTFS_END=`printf "0x%x" $ROOTFS_END`
sed -i "s/linux,initrd-end.*/linux,initrd-end = <$ROOTFS_END>;/g" $2.dts.txt

if [ $2 == 'dh7200' ]; then
	dtc -I dts -O dtb dh7200.dts.txt > hw.dtb
	cp gdbinit.dh7200.txt gdbinit -f
elif [ $2 == 'fpga' ]; then
	dtc -I dts -O dtb fpga.dts.txt > hw.dtb
	cp gdbinit.fpga.txt gdbinit -f
else
	echo "No support"
	return 0
fi

if [ $2 == 'fpga' ]; then
# Init DDR
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x ddrinit.txt ddr_init_elf
fi

# Run linux
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x gdbinit -ex "c" -ex "q"
