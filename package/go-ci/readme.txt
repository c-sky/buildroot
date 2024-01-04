go is too big;
用nfs来使用go 测试集
mkdir -p /home/rtos_nfs
mount -t nfs 192.168.0.204:/home/rtos_nfs /home/rtos_nfs -o nolock,tcp
cd /home/rtos_nfs/xuhj/ci
./go_run  或者  ./go_run_all
改目录下还有sit测试集的其他一些脚本
