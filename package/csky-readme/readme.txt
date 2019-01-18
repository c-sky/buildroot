Build from buildroot
====================

  $ git clone https://gitlab.com/c-sky/buildroot.git
  $ cd buildroot
  $ git checkout <buildroot-version>
  $ make <buildroot-config>
  $ make

Result of the build
-------------------

    output/images/
    ├── csky_buildroot_version.txt (Contain version details)
    ├── <buildroot-config>_<buildroot-version>.tar.xz
    ├── linux-<kernel-version>.patch.xz
    ├── qemu.dtb
    ├── rootfs.cpio.xz
    ├── vmlinux.xz
    └── readme.txt

How to Run
==========

Download all files above.
  $ cd output/images
  $ xz -d vmlinux.xz
  $ cd ..
  $ mkdir host
  $ tar -Jxf images/<buildroot-config>_<buildroot-version>.tar.xz -C ./host

Run on physical board:
1. Open a minicom-like serial program in a command window and receive from /dev/ttyUSB0
2. Open DebugServerConsole in another command window and make sure it connects with the board
3. Use csky-linux-gdb to download vmlinux as following commands:
	./csky-linux-gdb -x gdbinit vmlinux
4. The log will show on your serial program and you can interact with the board

Run on qemu with single core(807, 810):
  $ LD_LIBRARY_PATH=./host/lib ./host/csky-qemu/bin/qemu-system-cskyv2 -machine virt -kernel images/vmlinux -dtb images/qemu.dtb -nographic

Run on qemu with multi core (860):
  $ LD_LIBRARY_PATH=./host/lib ./host/csky-qemu/bin/qemu-system-cskyv2 -M mp860 -smp 2 -kernel images/vmlinux -dtb images/qemu_smp.dtb -nographic

Run on qemu with network:
  You need setup tap0 in your host PC first, execute the commands above with the suffix below:
  -net nic -net tap,ifname=tap0

Build linux kernel
==================

Download the clean kernel source from kernel.org

  $ wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-<kernel-version>.tar.xz
  $ tar -Jxf linux-<kernel-version>.tar.xz

  $ xz -d rootfs.cpio.xz
  $ xz -d linux-<kernel-version>.patch.xz

Patch linux kernel

  $ cd linux-<kernel-version>
  $ patch -p1 < ../linux-<kernel-version>.patch

Build linux kernel

  $ BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=../toolchain/bin/csky-linux- vmlinux
