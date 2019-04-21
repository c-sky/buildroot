# Set the JTAG address according to C-SKY debugserver settings
target jtag jtag://127.0.0.1:1025
set height 0

set $mcr30 = 0xc000000e

# Invalid L1-cache include I/Dcache
set $cr31 = 0xfff
set $cr17 = (1<<4) | 0x3
# Enable L1 cache and MMU and other CPU features
set $cr18 = 0x187d

# Invalid L2 cache
set $cr24 = (1<<4)
# Enable L2 cache
set $cr23 = 0x1018

# Pass the devicetree blob(dtb) store address to Linux kernel
set $r1 = 0x8F000000

# Store the devicetree blob(dtb) file to the store address above
restore fpga-single.dtb binary 0x8F000000

# Load the debugging elf file
load

# Sync I/Dcache before run kernel
set $cr17 = 0x33
c
q
