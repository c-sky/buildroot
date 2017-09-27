#!/bin/sh
dd if=/dev/zero of=./output/images/.temp.bin bs=512 count=24
cat ./output/images/u-boot-spl.bin ./output/images/.temp.bin >> ./output/images/.temp_a.bin
dd if=./output/images/.temp_a.bin of=./output/images/.temp_b.bin bs=512 count=24
cat ./output/images/.temp_b.bin ./output/images/u-boot.bin >> ./output/images/spl_uboot.bin
rm -f ./output/images/.temp.bin ./output/images/.temp_a.bin ./output/images/.temp_b.bin

