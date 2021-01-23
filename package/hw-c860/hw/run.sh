if [ $# -lt 1 -o $# -gt 3 ] ; then
	echo "Usage: . run.sh <ip:port> [ice_evb/an/eg/ve/by] [1/2/3/4]"
	echo "Usage: [an/eg/ve] is for platform"
	echo "Usage: [1/2/3/4] is for cpu quantity"
	exit 1
fi

BOARD="eg"
NRCORE=2

for idx in "$@"
do
if [ $idx == "ice_evb" ]; then
	BOARD="ice_evb"
elif [ $idx == "ice_evb_nfs" ]; then
	BOARD="ice_evb_nfs"
elif [ $idx == "ice_fpga" ]; then
	BOARD="ice_fpga"
elif [ $idx == "an" ]; then
	BOARD="an"
	NRCORE=2
elif [ $idx == "eg" ]; then
	BOARD="eg"
elif [ $idx == "ve" ]; then
	BOARD="ve"
elif [ $idx == "by" ]; then
	BOARD="by"
	NRCORE=1
elif [ $idx == "s" ]; then
	NRCORE=1
elif [ $idx == "m" ]; then
	NRCORE=2
fi

case "$idx" in
[1-9] | [1-1][0-6])
	NRCORE=$idx
esac
done

set -ex

DDRINIT=ddrinit.$BOARD.txt
GDBINIT=gdbinit.$BOARD.txt
DTS=$BOARD.dts.txt

echo "Use config" $NRCORE $BOARD
if [ ! -f $GDBINIT -o ! -f $DTS ]; then
	echo "No support"
	exit 1
fi

enable_dts_cores() {
	let x=$1-1
	for ((i=1;i<=$x;i++)); do
		y=`awk '/cpu@'$i' \{/{getline a;print NR}' .hw.dts`
		let y=$y+2
		sed -i ''$y','$y's/fail/okay/g' .hw.dts
	done
}

cp $DTS .hw.dts
if [ $NRCORE -gt 1 ] ; then
enable_dts_cores $NRCORE
fi

set -ex

#setup_initrd_addr .hw.dts
chmod 755 setup_initrd.sh
./setup_initrd.sh .hw.dts

./dtc -I dts -O dtb .hw.dts > hw.dtb

# Init DDR
if [ $BOARD == "by" ]; then
	echo "No need ddr_init for by DVB board"
elif [ $BOARD == "ve" ]; then
	echo "No need ddr_init for veloce"
elif [ $BOARD == "an" ]; then
	echo "No need ddr_init for anole board"
elif [ $BOARD == "eg" ]; then
./csky-linux-gdb -ex "tar remote $1" -x $DDRINIT ddr_init_$BOARD\_elf -ex "c" -ex "q" > /dev/null
else
./csky-linux-gdb -ex "tar remote $1" -x $DDRINIT -ex "q"
fi

# Run linux
./csky-linux-gdb -ex "tar remote $1" -x $GDBINIT -ex "c" -ex "q"
