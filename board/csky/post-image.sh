#!/bin/sh
# copy board/csky/xxx/gdbinit to images/.gdbinit for
BOARD_DIR="$(dirname $0)"
if [ ! -f $BINARIES_DIR/gdbinit ]; then
	cp -af $BOARD_DIR/${2}/gdbinit $BINARIES_DIR/gdbinit
fi

