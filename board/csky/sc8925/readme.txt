C-SKY Development Kit

Intro
=====

C-SKY is a CPU Architecture from www.c-sky.com and has it own instruction set.
Just like arm and mips in linux/arch, it named as 'csky'.

sc8925 SOC is from http://www.silan.com.cn

How to build it
===============

  $ make csky_sc8925_defconfig
  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── vmlinux
    ├── rootfs.tar
    └── sc8925.dtb

How to run it
=============

1. Download the Jtag-Server here:

   https://github.com/c-sky/tools/raw/master/DebugServerConsole-linux-x86_64-V4.2.00-20161213.sh

   install it:
   sudo ./DebugServerConsole-linux-x86_64-V4.2.00-20161213.sh -i

   run it:

   $ DebugServerConsole -ddc -rstwait 1000 -prereset -port 1025

2. Prepare the nfs-server in your linux PC. You can get the step in google, we
   don't mention it here.

   Then extract output/images/rootfs.tar to your nfs root.

3. Modified the "bootargs=" in board/csky/sc8925/sc8925.dts'. You must
   specify the correct nfsroot= and ip= by your own PC enviornment.

   '$ make linux-rebuild' again to update the dts in output/images

4. Setup the Console with the rate 115200/8-N-1.

5. run.
   $ cd output/images
   $ ../host/usr/bin/csky-abiv2-linux-gdb -x ../../board/csky/sc8925/gdbinit vmlinux

