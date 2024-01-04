# Buildroot
For Xuantie CPU Series Kernel build

# Introduction
Buildroot is a tool that simplifies and automates the process of building a complete Linux system for an embedded system, using cross-compilation. In order to achieve this, Buildroot is able to generate a cross-compilation toolchain, a root filesystem, a Linux kernel image and a bootloader for your target. Buildroot can be used for any combination of these options, independently (you can for example use an existing cross-compilation toolchain, and build only your root filesystem with Buildroot).

This repositery is based on buildroot official repo and project-specific customization is made for Xuantie CPU Series' opensource ecosystem.

# Quick Start

### clone repository

```bash
git clone https://github.com/c-sky/buildroot.git
cd buildroot
```

### choose a suitable config file

Multiple customized config files are provided in folder `configs_enhanced`

CPU | suitable config file
--- | ---
C910v2 | thead_910v2_enhanced_5.10_glibc_br_defconfig
C920v2 | thead_920v2_enhanced_5.10_glibc_br_defconfig
C906, C908, C910v1 | thead_9xxf_enhanced_5.10_glibc_br_defconfig
C920v1 | thead_9xxv0p7_enhanced_5.10_glibc_br_defconfig
C908v | thead_9xxv_enhanced_5.10_glibc_br_defconfig 


### Build kernel opensbi & rootfs

```bash
make CONF=thead_9xxf_enhanced_5.10_glibc_br_defconfig
```

Then inside image folder `thead_9xxf_enhanced_5.10_glibc_br_defconfig/images/` you will get:
```bash
fw_jump.bin    # OpenSPI with jump address mode
fw_dynamic.bin # OpenSPI with dynamic info mode
Image          # Linux Kernel image    
rootfs.ext2    # Root filesystem 

```


### Use Qemu boot Linux

```bash
./host/csky-qemu/bin/qemu-system-riscv64 
-M virt -cpu c910 \
-kernel ./images/fw_jump.bin \
-device loader,file=./images/Image,addr=0x80200000 \
-append "rootwait root=/dev/vda ro" \
-drive file=./images/rootfs.ext2,format=raw,id=hd0 \
-device virtio-blk-device,drive=hd0 \
-nographic -smp 2
```


### Using FPGA boot Linux

For booting linux with FPGA, dts, gdbinit scripts also will be needed, apart from kernel and rootfs. thoes scripts can be found inside folder  `thead_9xxf_enhanced_5.10_glibc_br_defconfig/images/hw`. please referring [documents](https://www.xrvm.cn/document?slug=linux-user-manual) for more details


### See Linux Booting
```bash
[    1.635084] VFS: Mounted root (ext4 filesystem) readonly on device 254:0.
[    1.638991] devtmpfs: mounted
[    1.671150] Freeing unused kernel memory: 252K
[    1.729521] Run /sbin/init as init process
[    1.861620] EXT4-fs (vda): warning: mounting unchecked fs, running e2fsck is recommended
[    1.866438] EXT4-fs (vda): re-mounted. Opts: (null)
Starting syslogd: OK
Starting klogd: OK
Running sysctl: OK
Starting mdev... OK
Initializing random number generator: OK
Saving random seed: [    5.720512] random: dd: uninitialized urandom read (512 bytes read)
OK
Starting network: OK
Starting telnetd: OK
processor       : 0
hart            : 0
isa             : rv64imafdcsu
mmu             : sv39
model name      : T-HEAD C910
freq            : 1.2GHz
icache          : 64kB
dcache          : 64kB
l2cache         : 2MB
tlb             : 1024 4-ways
cache line      : 64Bytes
address sizes   : 40 bits physical, 39 bits virtual
vector version  : 0.7.1

processor       : 1
hart            : 1
isa             : rv64imafdcsu
mmu             : sv39
model name      : T-HEAD C910
freq            : 1.2GHz
icache          : 64kB
dcache          : 64kB
l2cache         : 2MB
tlb             : 1024 4-ways
cache line      : 64Bytes
address sizes   : 40 bits physical, 39 bits virtual
vector version  : 0.7.1

Skip the ci test

Welcome to Buildroot
buildroot login:
```

# Resources
 - [https://www.xrvm.cn/vendor/cpu/cpuList](https://www.xrvm.cn/vendor/cpu/cpuList)
 - [https://www.xrvm.cn/product/list/xuantie](https://www.xrvm.cn/product/list/xuantie)
 - [https://www.xrvm.cn/document?slug=linux-user-manual](https://www.xrvm.cn/document?slug=linux-user-manual)
 - [https://github.com/T-head-Semi/opensbi](https://github.com/T-head-Semi/opensbi)
 - [https://github.com/T-head-Semi/linux](https://github.com/T-head-Semi/linux)

