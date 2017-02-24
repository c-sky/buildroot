################################################################################
#
# Linux kernel csky arch
#
################################################################################

LINUX_EXTENSIONS += csky-arch

define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
endef

