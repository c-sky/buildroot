################################################################################
#
# Linux kernel csky arch
#
################################################################################

LINUX_EXTENSIONS += csky-arch

define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
	if [ !$(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS) ]; then \
		mkdir $(LINUX_DIR)/addons; \
		touch $(LINUX_DIR)/addons/Kconfig; \
		touch $(LINUX_DIR)/addons/Makefile; \
	fi
endef

