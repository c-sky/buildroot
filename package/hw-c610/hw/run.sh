if [ $# -lt 1 ]; then
	echo "Usage: . run.sh <ip:port>"
	return 0
fi

dtc -I dts -O dtb gx6605s.dts.txt > hw.dtb

set -ex

# Run linux
../../host/bin/csky-linux-gdb -ex "tar remote $1" -x gdbinit.txt -ex "c" -ex "q"
