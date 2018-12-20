################################################################################
#
# Linux kernel csky arch
#
################################################################################

LINUX_EXTENSIONS += csky-arch

define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
	if [ -d $(CSKY_ARCH_DIR)/arch-csky-drivers ]; then \
		cp -raf $(CSKY_ARCH_DIR)/arch-csky-drivers $(LINUX_DIR)/; \
	fi
	if [ -d $(CSKY_ARCH_DIR)/drivers ]; then \
		cp -raf $(CSKY_ARCH_DIR)/drivers $(LINUX_DIR)/arch-csky-drivers; \
	fi
	awk '/:= drivers/{print $$0,"arch-csky-drivers/";next}{print $$0}' \
		$(LINUX_DIR)/Makefile 1<>$(LINUX_DIR)/Makefile
endef
