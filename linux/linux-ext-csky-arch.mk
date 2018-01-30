################################################################################
#
# Linux kernel csky arch
#
################################################################################

LINUX_EXTENSIONS += csky-arch

ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS),y)
define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
	echo "drivers-y += addons/" >> $(LINUX_DIR)/arch/csky/Makefile
	echo "source \"addons/Kconfig\"" >> $(LINUX_DIR)/arch/csky/Kconfig
endef
else
define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
endef
endif
