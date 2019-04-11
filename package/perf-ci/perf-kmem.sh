#!/bin/sh
# ./$@    only exec one time
# ./$@ 1  only exec one time
# ./$@ 2  only exec two time
# ./$@ 0  always run not stop

run_check_file()
{
    cmd="$1"
    file="$2"
    if [ -s $file ];then
        echo "PASS: $cmd"
    else
        echo "FAIL: $cmd"
        return  1
    fi
}

run_cmd()
{
    cmd="$1"
    log="$2"
    if [ $# = 2 ];then
        check_file="$2"
    else
        check_file="$3"
    fi
    [ -f $log ] && rm -f $log
    $cmd > $log 2>&1
    run_check_file "$cmd" "$check_file"
}
run_check_max()
{
    log="$1"
    log_cmp="$2"
    bit="$3"
    cmd1=`echo $log_cmp|awk -F '.' '{print $1}'|awk -F '-' '{print $3}'`
    cmd2=`echo $log_cmp|awk -F '.' '{print $1}'|awk -F '-' '{print $4}'`
    linenum=`cat $log|wc -l`
    linenum_last8=`expr $linenum - 8`
    num=`cat $log|sed -e ''"$linenum_last8"',$d'|sed -e '1,4d'|awk -v n="$bit"  '{print $n}'|awk '{print $1}'|awk -F '/' '{print $1}'|awk -F '.' '{print $1}'|sort` 
    max=`cat $log_cmp|sed -e ''"$linenum_last8"',$d'|sed -e '1,4d'|awk -v n="$bit"  '{print $n}'|awk '{print $1}'|awk -F '/' '{print $1}'|awk -F '.' '{print $1}'|head -1` 
    max_exp=0
    for i in `echo $num`
    do
        if [ $max_exp -lt $i ];then
                max_exp=$i
        fi
    done
    if [ "$max_exp" = "$max" ];then
        echo "PASS: perf kmem stat --$cmd1 -s $cmd2"
    else
        echo "FAIL: perf kmem stat --$cmd1 -s $cmd2"
    fi
}
run()
{
    run_cmd "perf kmem record ls"               "/dev/null"             "perf.data"
    run_cmd "perf kmem stat"                    "/tmp/perf-kmem.log" 
    run_cmd "perf kmem stat -v"                 "/tmp/perf-kmem-v.log"
    run_cmd "perf kmem stat --caller"           "/tmp/perf-kmem-caller.log"
    run_cmd "perf kmem stat --caller -s hit"    "/tmp/perf-kmem-caller-hit.log"
    run_cmd "perf kmem stat --caller -s frag"   "/tmp/perf-kmem-caller-frag.log"
    run_cmd "perf kmem stat --caller -s bytes"  "/tmp/perf-kmem-caller-bytes.log"
    run_cmd "perf kmem stat --alloc"            "/tmp/perf-kmem-alloc.log"
    run_cmd "perf kmem stat --alloc -s hit"     "/tmp/perf-kmem-alloc-hit.log"
    run_cmd "perf kmem stat --alloc -s frag"    "/tmp/perf-kmem-alloc-frag.log"
    run_cmd "perf kmem stat --alloc -s bytes"   "/tmp/perf-kmem-alloc-bytes.log"
    run_cmd "perf kmem stat --alloc -l 5"       "/tmp/perf-kmem-alloc-l5.log"
    run_cmd "perf kmem stat --alloc -l 3"       "/tmp/perf-kmem-alloc-l3.log"
    run_cmd "perf kmem stat --alloc --raw-ip"   "/tmp/perf-kmem-alloc-rawip.log"
    #run_cmd "perf kmem record --page ls"        "/dev/null"             "perf.data"
    #run_cmd "perf kmem stat --alloc --page"   "/tmp/perf-kmem-alloc-page.log"
    run_check_max "/tmp/perf-kmem-alloc.log" "/tmp/perf-kmem-alloc-hit.log" "7"
    run_check_max "/tmp/perf-kmem-alloc.log" "/tmp/perf-kmem-alloc-frag.log" "11"
    run_check_max "/tmp/perf-kmem-alloc.log" "/tmp/perf-kmem-alloc-bytes.log" "3"
    run_check_max "/tmp/perf-kmem-caller.log" "/tmp/perf-kmem-caller-hit.log" "7"
    run_check_max "/tmp/perf-kmem-caller.log" "/tmp/perf-kmem-caller-frag.log" "11"
    run_check_max "/tmp/perf-kmem-caller.log" "/tmp/perf-kmem-caller-bytes.log" "3"
}
if [ $# = 0 ];then
    run
else
    if [ "$1" = "0" ];then
        while true;do
            run
        done
    else
        for i in `seq 1 $1`
        do
            run
        done
    fi
fi
