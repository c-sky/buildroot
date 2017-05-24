################################################################################
#
# csky-qemu
#
################################################################################

CSKY_QEMU_VERSION = 20170511
CSKY_QEMU_SOURCE = csky-qemu-x86_64-$(CSKY_QEMU_VERSION).tar.gz
CSKY_QEMU_SITE = https://github.com/c-sky/tools/raw/master

define HOST_CSKY_QEMU_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/csky-qemu
	cp -raf $(@D)/* $(HOST_DIR)/csky-qemu
endef

$(eval $(host-generic-package))
