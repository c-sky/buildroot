#!/bin/sh
dd if=/dev/zero of=./temp.bin bs=512 count=24
cat ./output/images/u-boot-spl.bin ./temp.bin >> temp_a.bin
dd if=./temp_a.bin of=./temp_b.bin bs=512 count=24
cat ./temp_b.bin ./output/images/u-boot.bin >> ./output/images/spl_uboot.bin
rm -f ./temp.bin ./temp_a.bin ./temp_b.bin ./output/images/u-boot-spl.bin ./output/images/u-boot.bin

