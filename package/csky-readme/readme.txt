(All is tested on 64bit-ubuntu 16.04)

Quick Start for qemu run
========================
 echo "Download"
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/toolchain_<buildroot-config>_<buildroot-version>.tar.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/Image.xz
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

Run with hardware
=================
 We could use Jtag to run kernel in any platforms, here are the tips:

 (Download tools)
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/toolchain_<buildroot-config>_<buildroot-version>.tar.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/Image.xz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/rootfs.cpio.gz
 wget -nc https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/raw/output/images/hw.tar.gz
 xz -d -k Image.xz
 tar zxvf hw.tar.gz

 (Start JtagServer with a hw target board)
 cd ./host/csky-jtag/C-Sky_DebugServer
 sudo ./DebugServerConsole.elf -setclk 6
 (It will show <ip:port> for run.sh connecting)

 (Open another console window for gdb connect)
 cd hw/
 bash run.sh <ip:port> <board_name> <cpu_number>

How to get dmesg without uart
=============================
 (We needn't uart to print for bootup, we could just use gdbmacro to dmesg from ram.)
 wget https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/kdump/gdbmacros.txt

 (In gdb)
 file <linux dir>/vmlinux
 source gdbmacros.txt
 dmesg

Gitlab-CI url
=============
 https://gitlab.com/c-sky/buildroot/-/jobs/<buildroot-job_id>/artifacts/browse/output/images/

Versions:

