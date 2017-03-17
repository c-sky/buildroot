################################################################################
#
# Linux kernel csky addons
#
################################################################################

LINUX_EXTENSIONS += csky-addons

define CSKY_ADDONS_PREPARE_KERNEL
	if [ -f $(CSKY_ADDONS_DIR)/addons/Kconfig ]; then \
		cp -raf $(CSKY_ADDONS_DIR)/addons $(LINUX_DIR)/addons; \
	else \
		cp -raf $(CSKY_ADDONS_DIR) $(LINUX_DIR)/addons; \
	fi
endef

