#!/bin/sh
cp -n ./board/csky/c860_sc_byhl/gdbinit ${BINARIES_DIR}
cp -n ./board/csky/c860_sc_byhl/readme.txt ${BINARIES_DIR}
mkdir -p ${BINARIES_DIR}/ddrinit
cp -nd ${BASE_DIR}/build/linux-4.9.56/addons/ddr_init/eragon3/* ${BINARIES_DIR}/ddrinit
