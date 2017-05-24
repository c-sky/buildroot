################################################################################
#
# csky-debug
#
################################################################################

CSKY_DEBUG_VERSION = V4.2.0-tmp-20170411
CSKY_DEBUG_SOURCE = DebugServerConsole-linux-x86_64-$(CSKY_DEBUG_VERSION).tar.gz
CSKY_DEBUG_SITE = https://github.com/c-sky/tools/raw/master

define HOST_CSKY_DEBUG_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/csky-debug
	cp -raf $(@D)/* $(HOST_DIR)/csky-debug
endef

$(eval $(host-generic-package))
