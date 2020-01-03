(All is tested on 64bit-ubuntu 16.04)

Quick Start for qemu run
========================
 echo "Download"
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/toolchain_<buildroot-config>_<buildroot-version>.tar.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/Image.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/uImage
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/fw_jump.elf
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/rootfs.ext2.xz

 echo "Extra"
 xz -d -k Image.xz
 xz -d -k rootfs.ext2.xz
 mkdir -p host
 tar -Jxf toolchain_<buildroot-config>_<buildroot-version>.tar.xz -C host

 echo "Run"
 qemu_start_cmd

 (Login with username "root", and no password)


Enable qemu network
===================
 sudo qemu_start_cmd -netdev tap,script=no,id=net0 -device virtio-net-device,netdev=net0
 (Please use sudo privilege, becasue qemu will setup tap device in your host)

 sudo ifconfig tap0 192.168.101.200
 (Configure tap0 in host)

 ifconfig eth0 192.168.101.23
 ping 192.168.101.200;
 (Configure eth0 in qemu)


Build linux kernel
==================
 echo "Download"
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/toolchain_<buildroot-config>_<buildroot-version>.tar.xz
 wget -nc https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-<kernel-version>.tar.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/linux-<kernel-version>.patch.xz

 echo "Extra"
 tar -Jxf linux-<kernel-version>.tar.xz
 xz -d -k linux-<kernel-version>.patch.xz
 mkdir -p host
 tar -Jxf toolchain_<buildroot-config>_<buildroot-version>.tar.xz -C host

 echo "Patch"
 cd linux-<kernel-version>
 patch -p1 < ../linux-<kernel-version>.patch

 echo "Compile"
 linux_compile_cmd


Build buildroot
===============
 git clone https://gitlab.com/c-sky/buildroot.git
 cd buildroot
 git checkout <buildroot-version>
 make CONF=<buildroot-config>


Gitlab-CI url
=============
 https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/browse/output/images/


Versions:
