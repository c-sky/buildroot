#!/bin/sh

BINARIES_DIR=$1

media_files_path="${BINARIES_DIR}/../build/csky-examples-*/media/"
media_img_name="${BINARIES_DIR}/media-partition.ext2"

if [ -x $media_files_path ]; then
	rm -f $media_img_name
	# The partition is 128MB (512*262144)
	genext2fs -b 131072 -d $media_files_path $media_img_name
fi

