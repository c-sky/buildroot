if [ $# -lt 1 -o $# -gt 4 ] ; then
	echo "Usage: . run.sh <ip:port> [an/eg/ve/ice] [s/m] noreset"
	echo "Usage: [an/eg/ve/ice] is for board name"
	echo "Usage: [s/m] is for onecore/twocore"
	exit 1
fi

BOARD="eg"
NRCORE=2

GDBRESET="reset"
if [ $4 == "noreset" ]; then
GDBRESET="noreset"
fi

for idx in "$@"
do
if [ $idx == "an" ]; then
	BOARD="an"
elif [ $idx == "ice" ]; then
	BOARD="ice"
elif [ $idx == "eg" ]; then
	BOARD="eg"
elif [ $idx == "ve" ]; then
	BOARD="ve"
	GDBRESET="noreset"
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

# Setup_initrd_addr .hw.dts
chmod 755 setup_initrd.sh
./setup_initrd.sh .hw.dts

./dtc -I dts -O dtb .hw.dts > hw.dtb

# reset
if [ $GDBRESET == "reset" ]; then
./riscv64-linux-gdb -ex "tar remote $1" -ex "reset" -ex "set confirm off" -ex "q"
fi

# Init DDR
if [ $BOARD == "ve" ]; then
	echo "No need ddr_init for veloce"
elif [ $BOARD == "eg" ]; then
./riscv64-linux-gdb -ex "tar remote $1" -x $DDRINIT ddr_init_$BOARD\_elf -ex "c" -ex "q" > /dev/null
else
./riscv64-linux-gdb -ex "tar remote $1" -x $DDRINIT -ex "q"
fi

# Run linux
./riscv64-linux-gdb -ex "tar remote $1" -x $GDBINIT -ex "c" -ex "q"
