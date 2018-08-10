C-SKY Development Kit

How to build it
===============

	$ make csky_anole_ck810_gerrit_defconfig
	$ make

Result of the build
-------------------

After building, you should obtain this tree:

	output/images/
	├── anole_ck810.dtb
	├── rootfs.cpio
	├── rootfs.tar
	├── u-boot.bin
	├── u-boot-spl.bin
	└── uImage

Run ddr_init
============

Check the 'ddr_init/anole/gdbinit', the IP and Port must be the same as DebugServer.

	e.g.
	tar jtag jtag://192.168.0.88:1025

Run gdb and load ddr_init.

	$ output/host/usr/bin/csky-linux-gdb -x ddr_init/anole/gdbinit ddr_init/anole/ddr_init_<version-info>.elf

Press 'c' or 'r' to run the ddr_init.

	0xfffe0004 in __start ()
	(cskygdb) c
	Continuing.

When '__exit_loop_start' is running, press 'q' to quit.

	0xfffe00a6 in __exit_loop_start ()
	(cskygdb) q

Run vmlinux
===========

Check the 'board/csky/anole_ck810/gdbinit', the IP and Port must be the same as DebugServer.

	e.g.
	tar jtag jtag://192.168.0.88:1025

Run gdb and load vmlinux.

	$ cd output/images
	$ ../host/usr/bin/csky-linux-gdb -x ../../board/csky/anole_ck810/gdbinit ../build/<linux-kernel-dir>/vmlinux

Press 'c' or 'r' to run the vmlinux.

