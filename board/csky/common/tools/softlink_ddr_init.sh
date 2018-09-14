#!/bin/bash

# If softlink exists but invalid, then delete it first
if [ -L ./ddr_init ] && [ ! -e ./ddr_init ]; then
	rm -f ./ddr_init
fi

if [ ! -L ./ddr_init ]; then
	ln -sf ${BASE_DIR}/build/linux-*/addons/ddr_init ./
fi

