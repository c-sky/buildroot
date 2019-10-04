if [ $# != 3 ]; then
	echo "Usage: . run.sh <ip:port> <s/m> <30/60>"
	return 0
fi

# Select dts
if [ $3 == '30' ]; then
	cp c960_lite_single_30M.dts.txt .c960_lite_single.dts
	cp c960_lite_mp_30M.dts.txt .c960_lite_mp.dts
elif [ $3 == '60' ]; then
	cp c960_lite_single_60M.dts.txt .c960_lite_single.dts
	cp c960_lite_mp_60M.dts.txt .c960_lite_mp.dts
else
	echo "No support"
	return 0
fi

if [ $2 == 's' ]; then
	dtc -I dts -O dtb .c960_lite_single.dts > c960_lite.dtb
elif [ $2 == 'm' ]; then
	dtc -I dts -O dtb .c960_lite_mp.dts > c960_lite.dtb
else
	echo "No support"
	return 0
fi

# Init DDR
./riscv64-linux-gdb -ex "tar remote $1" -x ddrinit.txt ddr_init_elf

# Run linux
./riscv64-linux-gdb -ex "tar remote $1" -x gdbinit.txt

