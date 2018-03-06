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
	awk '/:= drivers/{print $$0,"addons/";next}{print $$0}'\
		$(LINUX_DIR)/Makefile 1<>$(LINUX_DIR)/Makefile
	echo "source \"addons/Kconfig\"" >> $(LINUX_DIR)/lib/Kconfig
endef

