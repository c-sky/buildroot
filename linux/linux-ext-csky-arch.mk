################################################################################
#
# Linux kernel csky arch
#
################################################################################

LINUX_EXTENSIONS += csky-arch

ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS),y)
define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
endef
else
define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
	mkdir $(LINUX_DIR)/addons
	touch $(LINUX_DIR)/addons/Kconfig
	touch $(LINUX_DIR)/addons/none.c
	echo "obj-y += none.o" > $(LINUX_DIR)/addons/Makefile
endef
endif
