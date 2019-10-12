###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION_4_9  = 6bd46102c9bb8a75878a59bb3a73a25aad4acb90
CSKY_ARCH_VERSION_4_14 = 247962b58f664bf03a9ceda11b4cda130f407411
CSKY_ARCH_VERSION_4_19 = 0d051420572338c04fc730b39ea4146e46cfe05a

CSKY_ARCH_VERSION = none

ifeq ($(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_9), y)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_9)
endif

ifeq ($(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_14), y)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_14)
endif

ifeq ($(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_19), y)
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
	cp $(CSKY_ARCH_DIR)/arch/csky $(LINUX_HEADERS_DIR)/arch -raf
endef
LINUX_HEADERS_POST_PATCH_HOOKS += LINUX_HEADERS_CSKY_ARCH
endif

$(eval $(generic-package))
endif
