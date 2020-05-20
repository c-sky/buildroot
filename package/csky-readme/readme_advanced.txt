
<<<<<<<<<<<<<< Advanced tips <<<<<<<<<<<<<<<<<<<<<<<<<

Quick Start for hw run
======================
 (Start JtagServer with a hw target board)
 cd ./host/csky-jtag/C-Sky_DebugServer
 sudo ./DebugServerConsole.elf -setclk 6

 (Open another console window for gdb connect)
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/toolchain_<buildroot-config>_<buildroot-version>.tar.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/Image.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/rootfs.cpio.gz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/hw.tar.gz
 xz -d -k Image.xz
 tar zxvf hw.tar.gz
 cd hw/
 bash run.sh 127.0.0.1:1025

Enable 9pfs in qemu
===================
mkdir -p /home/csky/shared
(create a dir in host)

sudo qemu_start_cmd -fsdev local,security_model=passthrough,id=fsdev0,path=/home/csky/shared -device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare
(start qemu)

mkdir -p /root/host_shared
(create a dir in qemu)

mount -t 9p -o trans=virtio,version=9p2000.L hostshare /root/host_shared/
(mount the directory on the host)

(Now, you can share the files between qemu and host through the diretory
created before.)

Enable qemu network
===================
 sudo qemu_start_cmd -netdev tap,script=no,id=net0 -device virtio-net-device,netdev=net0
 (Please use sudo privilege, becasue qemu will setup tap device in your host)

 sudo ifconfig tap0 192.168.101.200
 (Configure tap0 in host)

 ifconfig eth0 192.168.101.23
 ping 192.168.101.200;
 (Configure eth0 in qemu)

Enable the gcov function in kernel
==================================
(Csky cpu now support the gcov function in kernel. But the Image size
 would be about 24M if this function is enbaled. So we disabled this function
 defaultly. If you want to enable it, please open the following config)

CONFIG_DEBUG_FS=y
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_GCOV_PROFILE_ALL=y
