#!/bin/sh

# copy some files into output/images/
if [ ! -f $BINARIES_DIR/.gdbinit ]; then
	cp -f board/csky/kdgd/gdbinit $BINARIES_DIR/.gdbinit
fi

