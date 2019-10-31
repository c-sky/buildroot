echo "Usage: . run.sh <ip:port>"

ROOTFS_BASE=`cat fpga.c860mp.dts.txt | grep initrd-start | awk -F "<" '{print $2}' | awk -F ">" '{print $1}'`
ROOTFS_SIZE=`ls -lt ../rootfs.cpio.gz | awk '{print $5}'`
((ROOTFS_END= $ROOTFS_BASE + $ROOTFS_SIZE))
ROOTFS_END=`printf "0x%x" $ROOTFS_END`
sed -i "s/linux,initrd-end.*/linux,initrd-end = <$ROOTFS_END>;/g" fpga.c860mp.dts.txt

dtc -I dts -O dtb fpga.c860mp.dts.txt > hw.dtb

# Init DDR
./csky-linux-gdb -ex "tar remote $1" -x ddrinit.txt ddr_init_elf -ex "c" -ex "q"

# Run linux
./csky-linux-gdb -ex "tar remote $1" -x gdbinit.c860mp.txt -ex "c" -ex "q"
