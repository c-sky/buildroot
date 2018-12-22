#!/bin/sh
cp -n ./board/csky/c860_sc_byhl/gdbinit ${BINARIES_DIR}
mkdir -p ${BINARIES_DIR}/ddr_init
cp -nd ${BASE_DIR}/build/linux-4.9.56/addons/ddr_init/eragon3/* ${BINARIES_DIR}/ddr_init
