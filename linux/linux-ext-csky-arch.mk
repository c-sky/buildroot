################################################################################
#
# Linux kernel csky arch
#
################################################################################

LINUX_EXTENSIONS += csky-arch

define CSKY_ARCH_PREPARE_KERNEL
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
	cp -raf $(CSKY_ARCH_DIR)/arch-csky-drivers $(LINUX_DIR)/
	awk '/:= drivers/{print $$0,"arch-csky-drivers/";next}{print $$0}' \
		$(LINUX_DIR)/Makefile 1<>$(LINUX_DIR)/Makefile
endef
