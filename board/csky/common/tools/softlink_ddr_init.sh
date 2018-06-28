#!/bin/bash

if [ ! -L ./ddr_init ]; then
	ln -sf ${BASE_DIR}/build/linux-*/addons/ddr_init ./
fi

