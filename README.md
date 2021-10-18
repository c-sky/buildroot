# Buildroot
For Xuantie CPU Series Kernel build

# Introduction
Buildroot is a tool that simplifies and automates the process of building a complete Linux system for an embedded system, using cross-compilation. In order to achieve this, Buildroot is able to generate a cross-compilation toolchain, a root filesystem, a Linux kernel image and a bootloader for your target. Buildroot can be used for any combination of these options, independently (you can for example use an existing cross-compilation toolchain, and build only your root filesystem with Buildroot).

This repositery is based on buildroot official repo and project-specific customization is made for Xuantie CPU Series' opensource ecosystem.

# Quick Start

## Chip & Board
ICE is a Xuantie C910 based high-performance SoC board developed by T-Head. The ICE SoC has integrated 3 Xuantie C910 cores (RISC-V 64) and 1 GPU core, featuring speed and intelligence with a high cost-effective ratio. The chip can provide 4K@60 HEVC/AVC/JPEG decoding ability and varieties of high-speed interfaces and peripherals for controlling and data exchange; suits for 3D graphics, visual AI, and multimedia processing.

![ice.png](https://github.com/T-head-Semi/aosp-riscv/blob/main/resources/ice.jpg?raw=true)

Graph 2. ICE chip

For more information about Xuantie 910 CPU core IP, please check: [**Xuantie C910 introduction**](https://occ.t-head.cn/vendor/cpu/index?spm=a2cl5.14294226.0.0.6700df2098XZyN&id=3806788968558108672)

More detials ref to: [**RVB-ICE**](https://occ.t-head.cn/community/risc_v_en/detail?id=RVB-ICE)

## Build boot.ext4 (kernel + opensbi + dtb) & rootfs

(Tested enviornment - ubuntu 16.04 amd64)

```bash
 git clone https://gitlab.com/c-sky/buildroot.git
 cd buildroot
 make CONF=thead_9xxf_enhanced_5.10_glibc_br_defconfig
 export PATH=$PATH:`pwd`/host/opt/ext-toolchain/bin
```

Then you will get:
```bash
 ls -l thead_9xxf_enhanced_5.10_glibc_br_defconfig/images/boot.ext4
 ls -l thead_9xxf_enhanced_5.10_glibc_br_defconfig/images/rootfs.ext2
```

## Build u-boot

```bash
git clone "https://gitee.com/thead-linux/u-boot.git" -b master
make ice_rvb_c910_defconfig
make -j ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu-
```

Then you will get:
```bash
u-boot-with-spl.bin
```

## Prepare flash tools in host

Using pip command install thead-tools into your system. (Please using python2)
```bash
sudo apt install python-pip
sudo apt install fastboot

sudo pip install thead-tools
sudo pip install -i https://pypi.tuna.tsinghua.edu.cn/simple thead-tools
```

## Flash the u-boot

Connect RVB-ICE UART with USB-Type-C to your host PC, ref:
[RVB-ICE Type-C UART](https://occ.t-head.cn/community/risc_v_en/detail?id=RVB-ICE)

```bash
root@linux > thead cct uart
uart device list:
   /dev/ttyUSB0 - USB-Serial Controller
   /dev/ttyUSB1 - USB-Serial Controller

root@linux > thead cct -u /dev/ttyUSB0 list
Wait .....................
CCT Version: 2
memory device list:
  dev = ram0   , size =  256.0KB
  dev = emmc0  , size =    2.0MB
  dev = emmc1  , size =    2.0MB
  dev = emmc2  , size =    3.7GB
```

We will put uboot into the emmc0:

```bash
thead cct -u /dev/ttyUSB0 download -f u-boot-with-spl.bin -d emmc0
CCT Version: 2
Send file 'u-boot-with-spl.bin' to 21:0 ...
Writing at 0x00009800... (3%)

Reset the board, and you will see:

U-Boot 2020.01-g6cc5d59b0d (Dec 20 2020 - 08:37:37 +0000)

CPU:   rv64imafdcvsu
Model: T-HEAD c910 ice
DRAM:  4 GiB
GPU ChipDate is:0x20151217
GPU Frequency is:500000KHz
NPU ChipDate is:0x20190514
DPU ChipDate is:0x20161213
MMC:   mmc0@3fffb0000: 0
Loading Environment from MMC... OK
In:    serial@3fff73000
Out:   serial@3fff73000
Err:   serial@3fff73000
Net:
Warning: ethernet@3fffc0000 (eth0) using random MAC address - e6:e2:ea:7a:30:ce
eth0: ethernet@3fffc0000
Hit any key to stop autoboot:  1
```

## Prepare u-boot env setting

In u-boot UART console to setup fastboot UDP server.

```bash
env default -a

setenv uuid_rootfs "80a5a8e9-c744-491a-93c1-4f4194fd690b"
setenv partitions "name=table,size=2031KB"
setenv partitions "$partitions;name=boot,size=60MiB,type=boot"
setenv partitions "$partitions;name=root,size=-,type=linux,uuid=$uuid_rootfs"
gpt write mmc 0 $partitions

setenv ethaddr 00:a0:a0:a0:a0:a1
setenv ipaddr 192.168.1.100 (Your IP)
setenv netmask 255.255.255.0
saveenv

fastboot udp
```

## Using fastboot install boot.ext4 & rootfs

```bash
fastboot -s udp:192.168.1.100 flash boot boot.ext4

fastboot -s udp:192.168.1.100 flash root rootfs.ext2
```

## Reset the board

Power on the board, you will get:
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
 - [https://occ.t-head.cn/community/risc_v_en/detail?id=RVB-ICE](https://occ.t-head.cn/community/risc_v_en/detail?id=RVB-ICE)
 - [https://occ.t-head.cn/community/risc_v](https://occ.t-head.cn/community/risc_v)
 - [https://occ.t-head.cn/vendor/cpu/cpuList](https://occ.t-head.cn/vendor/cpu/cpuList)
 - [https://github.com/T-head-Semi/u-boot](https://github.com/T-head-Semi/u-boot)
 - [https://github.com/T-head-Semi/opensbi](https://github.com/T-head-Semi/opensbi)
 - [https://github.com/T-head-Semi/linux](https://github.com/T-head-Semi/linux)
