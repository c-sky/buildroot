C-SKY Development Kit

Intro
=====

C-SKY is a CPU Architecture from www.c-sky.com and has it own instruction set.
Just like arm and mips in linux/arch, it named as 'csky'.

For C-SKY linux kernel it's made up of three components:
1. linux/arch/csky contains the CPU related linux arch implement, eg: mmu,
   task-switch, cache control, ... default git repo is here:

   http://github.com/c-sky/csky-linux

2. linux/addons contains the SOC's drivers which haven't committed in official
   linux source code, but we really need them to make the board run.
   Here is the default addons git repo:

   http://github.com/c-sky/csky-addons

   Some C-SKY soc vendor has it own addons git repo. And you can specify
   the git-repo in buildroot configuration.

3. Official Linux kernel source from www.kernel.org :)

Buildroot will download cross compiler tools and make them together building,
finally setup the rootfs with the packages which spicified in buildroot 
configuration.

How to build it
===============

Configure Buildroot
-------------------

The csky_gx6605s_defconfig configuration is a sample configuration with
all that is required to bring the gx6605s Development Board:

  $ make csky_gx6605s_defconfig

and for the sc8925 Development Board:

  $ make csky_sc8925_defconfig

Build everything
----------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

  $ make # All will be done, just wait :)

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── vmlinux
    ├── rootfs.tar
    ├── <board name>.dtb
    └── .gdbinit

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

   Then extract output/images/rootfs.tar to your nfsroot.

3. Modified the bootargs in board/csky/<board>/<board>.dts'. You should
   specify the correct nfsroot= and ip=, for example in gx6605s.dts:

	chosen {
   		bootargs = "console=ttyS0,115200 init=/sbin/init root=/dev/nfs\
rw nfsroot=192.168.101.230:/opt/nfs/test,v3,tcp,nolock ip=192.168.101.25";
	}

   You need cd to buildroot dir and '$ make' again to update the dts in
   output/images

   <board>.dts also contains the IP devices and drivers supported.

4. Setup the Console with the rate 115200/8-N-1.

5. cd to the output/images and run.

   For gx6605s, you need plug a usb ethernet card:
   $csky-linux-gdb vmlinux

   For sc8925:
   $csky-abiv2-linux-gdb vmlinux

Finish
======

Any question contact me here:

ren_guo@c-sky.com

-----------
Best Regards

Guo Ren

