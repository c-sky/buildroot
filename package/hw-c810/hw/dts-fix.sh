function get_kernel_version()
{
	kernel_ver=`grep -nr "KERNEL-TAG" $1 | awk -F ":" '{print $3}' | awk -F "\"" '{print $2}'`
	echo "kerenl version is $kernel_ver"
}

get_kernel_version $1

if [ $kernel_ver == 4.9.56 ]; then
	echo "start form eth0"
	sed -i 's\BOOT_DEVICE\eth0\g' $1
else
	echo "start from eth1"
	sed -i 's\BOOT_DEVICE\eth1\g' $1
fi
