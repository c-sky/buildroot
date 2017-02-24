################################################################################
#
# Linux kernel csky addons
#
################################################################################

LINUX_EXTENSIONS += csky-addons

define CSKY_ADDONS_PREPARE_KERNEL
	cp -raf $(CSKY_ADDONS_DIR) $(LINUX_DIR)/addons
endef

