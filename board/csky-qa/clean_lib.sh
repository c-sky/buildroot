#!/bin/bash
TOPDIR=`pwd`
TARGET_DIR=$TOPDIR/output/target/lib
cd $TARGET_DIR
for i in `ls -l |awk '/^d/ {print $NF}'`
do
	if [ "$i" = "big" ] || [ "$i" = "hard-fp" ] || [ "$i" = "stm" ] || [[ "$i" =~ "ck" ]];then
		echo "Delete $i ..."
		rm -rf $i
	fi
done
