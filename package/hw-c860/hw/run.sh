if [ $# != 1 ]; then
	echo "Usage: . run.sh <ip:port>"
	return 0
fi

rm -f hw.dtb;
rm -f gdbinit;
dtc -I dts -O dtb fpga.c860mp.dts.txt > hw.dtb
cp gdbinit.c860mp.txt gdbinit -f

# Init DDR
./csky-linux-gdb -ex "tar remote $1" -x ddrinit.txt ddr_init_elf

# Run linux
./csky-linux-gdb -ex "tar remote $1" -x gdbinit -ex "c"
