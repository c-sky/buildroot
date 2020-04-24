if [ $# != 2 ]; then
	echo "Usage: . run.sh <ip:port> <dh7200/fpga/dp1000>"
	return 0
fi

if [ $2 == 'dh7200' ]; then
	cp dh7200.dts.txt .hw.dts -f
	cp gdbinit.dh7200.txt gdbinit -f
elif [ $2 == 'fpga' ]; then
	cp fpga.dts.txt .hw.dts -f
	cp gdbinit.fpga.txt gdbinit -f
elif [ $2 == 'dp1000' ]; then
	cp dp1000.dts.txt .hw.dts -f
	cp gdbinit.dp1000.txt gdbinit -f
else
	echo "No support"
	return 0
fi

set -ex

#setup_initrd_addr .hw.dts
chmod 755 setup_initrd.sh
./setup_initrd.sh .hw.dts

./dtc -I dts -O dtb .hw.dts > hw.dtb

if [ $2 == 'fpga' ]; then
# Init DDR
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x ddrinit.txt ddr_init_elf > /dev/null
fi

# Run linux
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x gdbinit -ex "c" -ex "q"
