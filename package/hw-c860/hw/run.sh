if [ $# != 2 ]; then
	echo "Usage: . run.sh <ip:port> <s/m>"
	return 0
fi

if [ $2 == 's' ]; then
	dtc -I dts -O dtb fpga.c860s.dts.txt > hw.dtb
	cp gdbinit.c860s.txt gdbinit -f
elif [ $2 == 'm' ]; then
	dtc -I dts -O dtb fpga.c860mp.dts.txt > hw.dtb
	cp gdbinit.c860mp.txt gdbinit -f
else
	echo "No support"
	return 0
fi

# Init DDR
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x ddrinit.txt ddr_init_elf

# Run linux
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x gdbinit

