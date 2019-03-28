(All is tested on 64bit-ubuntu 16.04)

Prepare
=======
Download these files from gitlab-CI web page (You can download them from gitlab-CI without building)

    output/images/
    ├── csky_buildroot_version.txt (Contain version details)
    ├── <buildroot-config>_<buildroot-version>.tar.xz
    ├── linux-<kernel-version>.patch.xz
    ├── qemu.dtb
    ├── rootfs.cpio.xz
    ├── vmlinux.xz
    └── readme.txt


Run on Qemu
===========
 xz -d vmlinux.xz;
 mkdir host;
 tar -Jxf <buildroot-config>_<buildroot-version>.tar.xz -C host;
 qemu_start_cmd;

 PS. If you want the net, you'll have to set tap0 on your PC firstly, and then run the following commands:
 qemu_start_cmd -nographic -net nic -net tap,ifname=tap0


Run on Board
============
 minicom -D /dev/ttyUSB0
 ./DebugServerConsole
 ./host/bin/csky-linux-gdb -x gdbinit vmlinux

 PS. Login with username "root", and no password


Build linux kernel
==================
 wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-<kernel-version>.tar.xz;
 tar -Jxf linux-<kernel-version>.tar.xz;
 xz -d rootfs.cpio.xz;
 xz -d linux-<kernel-version>.patch.xz;
 cd linux-<kernel-version>;
 patch -p1 < ../linux-<kernel-version>.patch;
 BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=../host/bin/csky-linux- vmlinux;


Build from buildroot
====================
 git clone https://gitlab.com/c-sky/buildroot.git;
 cd buildroot;
 git checkout <buildroot-version>;
 make <buildroot-config>;
 make;
