#!/bin/sh
install -D -m 0644 board/csky/sc6138a/gdbinit ${BINARIES_DIR}/.gdbinit
install -D -m 0644 board/csky/sc6138a/u-boot ${BINARIES_DIR}/u-boot
