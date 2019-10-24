if [ $# != 2 ]; then
	echo "Usage: . run.sh <ip:port> <gx6605s/gx6622>"
	return 0
fi

if [ $2 == 'gx6605s' ]; then
	dtc -I dts -O dtb gx6605s.dts.txt > hw.dtb
elif [ $2 == 'gx6622' ]; then
	dtc -I dts -O dtb gx6622.dts.txt > hw.dtb
else
	echo "No support"
	return 0
fi

# Run linux
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x gdbinit.txt -ex "c" -ex "q"
