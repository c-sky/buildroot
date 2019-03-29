(All is tested on 64bit-ubuntu 16.04)

Quick Start
===========
 echo "First download the files.";
 wget https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/csky_toolchain_<buildroot-config>_<buildroot-version>.tar.xz;
 wget https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/qemu_what.dtb;
 wget https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/vmlinux.xz;

 echo "Now let's run on qemu";
 xz -d vmlinux.xz;
 mkdir host;
 tar -Jxf csky_toolchain_<buildroot-config>_<buildroot-version>.tar.xz -C host;
 qemu_start_cmd;

 (PS. Login with username "root", and no password)


Build linux kernel
==================
 wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-<kernel-version>.tar.xz;
 wget https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/linux-<kernel-version>.patch.xz;
 tar -Jxf linux-<kernel-version>.tar.xz;
 xz -d rootfs.cpio.xz;
 xz -d linux-<kernel-version>.patch.xz;
 cd linux-<kernel-version>;
 patch -p1 < ../linux-<kernel-version>.patch;
 BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=../host/bin/csky-linux- vmlinux;


Build buildroot
===============
 git clone https://gitlab.com/c-sky/buildroot.git;
 cd buildroot;
 git checkout <buildroot-version>;
 make <buildroot-config>;
 make;


Enable qemu network
===================
 If you want the net, you'll have to set tap0 on your PC firstly, and then run the following command:
 qemu_start_cmd -net nic -net tap,ifname=tap0;


Run with Jtag
=============
 minicom -D /dev/ttyUSB0
 sudo ./host/csky-debug/DebugServerConsole.elf
 ./host/bin/csky-linux-gdb -x gdbinit vmlinux


Gitlab-CI url
=============
 https://gitlab.com/c-sky/buildroot/-/jobs/186469541/artifacts/file/output/images/
