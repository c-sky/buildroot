(All is tested on 64bit-ubuntu 16.04)

Prepare
=======

Download all files from gitlab-CI web page

    output/images/ (You can download them from gitlab CI without build)
    ├── csky_buildroot_version.txt (Contain version details)
    ├── <buildroot-config>_<buildroot-version>.tar.xz
    ├── linux-<kernel-version>.patch.xz
    ├── qemu.dtb
    ├── rootfs.cpio.xz
    ├── vmlinux.xz
    └── readme.txt

How to Run
==========

  $ xz -d vmlinux.xz
  $ mkdir host
  $ tar -Jxf <buildroot-config>_<buildroot-version>.tar.xz -C host

Run on qemu with single core(807, 810):
  $ LD_LIBRARY_PATH=./host/lib ./host/csky-qemu/bin/qemu-system-cskyv2 -machine virt -kernel vmlinux -dtb qemu.dtb -nographic

Run on qemu with multi core (860):
  $ LD_LIBRARY_PATH=./host/lib ./host/csky-qemu/bin/qemu-system-cskyv2 -M mp860 -smp 2 -kernel vmlinux -dtb qemu_smp.dtb -nographic

Run on qemu with network:
  You need setup tap0 in your host PC first, execute the commands above with the suffix below:
	-net nic -net tap,ifname=tap0

Run on physical board:
1. Open a minicom-like serial program in a command window (eg: minicom -D /dev/ttyUSB0)
2. Open DebugServerConsole in another command window and make sure it connected to board
3. Use csky-linux-gdb as following commands:
	./host/bin/csky-linux-gdb -x gdbinit vmlinux
4. See serial program (eg: minicom you opened) and you will get login prompt (username: root, no password)

Build linux kernel
==================

Download the clean kernel source from kernel.org:

  $ wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-<kernel-version>.tar.xz
  $ tar -Jxf linux-<kernel-version>.tar.xz

Prepare rootfs.cpio:
  $ xz -d rootfs.cpio.xz

Patch linux kernel:

  $ xz -d linux-<kernel-version>.patch.xz
  $ cd linux-<kernel-version>
  $ patch -p1 < ../linux-<kernel-version>.patch

Build linux kernel:

  $ BR_BINARIES_DIR=.. make ARCH=csky CROSS_COMPILE=../host/bin/csky-linux- vmlinux

Build from buildroot
====================

All you try could

  $ git clone https://gitlab.com/c-sky/buildroot.git
  $ cd buildroot
  $ git checkout <buildroot-version>
  $ make <buildroot-config>
  $ make
