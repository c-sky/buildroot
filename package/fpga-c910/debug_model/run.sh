if [ $# != 3 ]; then
	echo "Usage: . run.sh <ip> <1/3> <30/60>"
	return 0
fi

cp ddrinit .ddrinit_$1
cp gdbinit .gdbinit_$1

sed -i "s/ip/$1/g" .ddrinit_$1
sed -i "s/ip/$1/g" .gdbinit_$1
sed -i "s/c960_lite/c960_lite_$1/g" .gdbinit_$1

if [ $3 == '30' ]; then
	cp c960_lite_single_30M.dts .c960_lite_single_$1.dts
	cp c960_lite_mp_30M.dts .c960_lite_mp_$1.dts
elif [ $3 == '60' ]; then
	cp c960_lite_single_60M.dts .c960_lite_single_$1.dts
	cp c960_lite_mp_60M.dts .c960_lite_mp_$1.dts
else
	echo "No shit"
	return 0
fi

if [ $2 == '1' ]; then
	dtc -I dts -O dtb .c960_lite_single_$1.dts > c960_lite.dtb
elif [ $2 == '3' ]; then
	dtc -I dts -O dtb .c960_lite_mp_$1.dts > c960_lite.dtb
else
	echo "No shit"
	return 0
fi
mv c960_lite.dtb c960_lite_$1.dtb

cp riscv64-linux-gdb riscv64-linux-gdb_$1
./riscv64-linux-gdb_$1 -x .ddrinit_$1 ddr_init_elf
./riscv64-linux-gdb_$1 -x .gdbinit_$1 bbl

rm .ddrinit_$1
rm .gdbinit_$1
rm riscv64-linux-gdb_$1
rm .c960_lite_single_$1.dts
rm .c960_lite_mp_$1.dts
rm c960_lite_$1.dtb
