# Set the JTAG address according to C-SKY debugserver settings
tar jtag jtag://192.168.0.88:1025

# Reset target board
reset

# Disable CPU cache
set $cr18=0x00

# Load the debugging elf file
load
