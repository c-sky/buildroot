#!/bin/sh
# copy board/csky/xxx/gdbinit to images/.gdbinit for
BOARD_DIR="$(dirname $0)"
cp -af $BOARD_DIR/${2}/gdbinit $BINARIES_DIR/.gdbinit
