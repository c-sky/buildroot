if [ $# != 2 ]; then
	echo "Usage: . run.sh <ip:port> <dh7200/fpga>"
	return 0
fi

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
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x gdbinit

