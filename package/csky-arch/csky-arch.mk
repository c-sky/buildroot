###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION_4_9  = 8b5be1e7481b2802f9f3b03ea836c8157fa138ec
CSKY_ARCH_VERSION_4_14 = 27b8ef7cc13fd58ab7f8263fffc4ecc6408bea16
CSKY_ARCH_VERSION_4_19 = e505e4033fce1650557ec99b9d10df8df5f31729

CSKY_ARCH_VERSION = none


ifneq ($(findstring y,$(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_9) $(BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_9)),)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_9)
endif

ifneq ($(findstring y,$(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_14) $(BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_14)),)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_14)
endif

ifneq ($(findstring y,$(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_19) $(BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_19)),)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_19)
endif

ifneq ($(CSKY_ARCH_VERSION), none)
CSKY_ARCH_SITE = $(call github,c-sky,csky-linux,$(CSKY_ARCH_VERSION))

define CSKY_ARCH_PREPARE_KERNEL
	cd $(CSKY_ARCH_DIR)/; bash merge.sh $(LINUX_DIR); cd -;
	echo "CFLAGS_cpu-probe.o := -DCSKY_ARCH_VERSION=\"\\\"$(CSKY_ARCH_VERSION)\\\"\"" >> $(LINUX_DIR)/arch/csky/kernel/Makefile;
endef
LINUX_POST_PATCH_HOOKS += CSKY_ARCH_PREPARE_KERNEL

# Prepare linux headers
ifeq ($(BR2_PACKAGE_LINUX_HEADERS), y)
LINUX_HEADERS_DEPENDENCIES += csky-arch
define LINUX_HEADERS_CSKY_ARCH
	cd $(CSKY_ARCH_DIR)/; bash merge.sh $(LINUX_HEADERS_DIR); cd -;
	echo "CFLAGS_cpu-probe.o := -DCSKY_ARCH_VERSION=\"\\\"$(CSKY_ARCH_VERSION)\\\"\"" >> $(LINUX_HEADERS_DIR)/arch/csky/kernel/Makefile;
endef
LINUX_HEADERS_POST_PATCH_HOOKS += LINUX_HEADERS_CSKY_ARCH
endif

$(eval $(generic-package))
endif
