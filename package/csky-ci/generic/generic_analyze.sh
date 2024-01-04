GET_START=n
ROOT_PATH=$(dirname "$0")/../../../
OUT_PATH=$(dirname "$0")/../../

#Parsh the result from lmbench & LTP etc.
echo "============= csky test sum ============="
sed -i 's/
//g' $ROOT_PATH/test.log
sed -i 's///g' $ROOT_PATH/test.log

function shut_down()
{
	killall DebugServerConsole.elf > /dev/null 2>&1
	killall csky_serial > /dev/null 2>&1
	./$OUT_PATH/host/csky-ci/csky_switch /dev/csky_switch off
}

shut_down

if grep -q "Freeing unused kernel" $ROOT_PATH/test.log; then
	echo "Linux kernel start successed!"
else
	echo "Linux kernel start failed!"
	exit 1
fi

RESULT=0
#Analyze the board result
if grep -q "csky-ci tests failed" $ROOT_PATH/test.log; then
	echo "Total failure. Check test.log"
	RESULT=$(($RESULT+1))
fi
if grep -q "9pfs tests failed" $ROOT_PATH/test.log; then
	echo "9pfs failure. Check test.log"
	RESULT=$(($RESULT+1))
fi

#Analyze the output(host) result
while read LINE
do
if [ "$GET_START" == "y" ]; then
	if [[ "$LINE" =~ "end =========" ]]; then
		GET_START=n
	fi
	echo $LINE >> $OUT
else
	if [[ "$LINE" =~ "start =========" ]]; then
		GET_START=y
		TEST=$(echo $LINE | awk '{print $2}')
		OUT=$ROOT_PATH/$TEST.log
		echo $LINE > $OUT
	fi
fi
done < $ROOT_PATH/test.log

num=`ls -A ./$OUT_PATH/host/csky-ci/parse_script/ | wc -w`

if [ $num == 0 ]; then
	exit $RESULT
fi

for i in ./$OUT_PATH/host/csky-ci/parse_script/*; do
	tmp=${i##*/}
	par=${tmp%%_*}.log
	if [ -f $par ]; then
		./$i $par
		RESULT=$(($RESULT+$?))
	fi
done

exit $RESULT
