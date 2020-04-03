start_line=`grep -wnr "device_type" $1 | grep "memory" | awk -F ":" '{print $1}'`
end_line=$(($start_line+2))

#grep -A 5 -C 2 "device_type" .hw.dts | grep "memory" | awk -F ":" '{print $1}'
echo "line numer is $start_line, $end_line"
sed -n "$start_line,$end_line p" .hw.dts > memory.txt

MEM_BASE=`cat memory.txt | grep -m 1 reg | awk -F "<" '{print $2}' | awk -F " " '{print $1}'`
MEM_MASK=0xf0000000

((MEM_BASE= $MEM_BASE & $MEM_MASK))
MEM_BASE=`printf "0x%x" $MEM_BASE`

ROOTFS_OFFSET=0x2000000
((ROOTFS_BASE= $MEM_BASE + $ROOTFS_OFFSET))
ROOTFS_BASE=`printf "0x%x" $ROOTFS_BASE`

ROOTFS_SIZE=`ls -lt ../rootfs.cpio.gz | awk '{print $5}'`
((ROOTFS_END= $ROOTFS_BASE + $ROOTFS_SIZE))
ROOTFS_END=`printf "0x%x" $ROOTFS_END`


echo "mem base is $MEM_BASE"
echo "base is $ROOTFS_BASE"
echo "size is $ROOTFS_SIZE"
echo "end is $ROOTFS_END"

sed -i '/initrd-start/d' $1
sed -i '/initrd-end/d' $1

sed -i "/bootargs/a\linux,initrd-start = <$ROOTFS_BASE>;" $1
sed -i "/initrd-start/a\linux,initrd-end = <$ROOTFS_END>;" $1
