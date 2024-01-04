###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION_4_9  = d0119869267485e447e3111fafce406a6c16d4a5
CSKY_ARCH_VERSION_4_14 = 05bdfa78c4eb8c097ae4f3679f373a551e19259f
CSKY_ARCH_VERSION_4_19 = 75203c166b7ff63d1b9c4369226828aeb6b4054b

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

ifeq ($(BR2_csky),y)
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
endif
CSKY_LINUX_NEXT_VERSION	= 88b06399c9c766c283e070b022b5ceafa4f63f19
CSKY_LINUX_NEXT_RISCV_VERSION	= $(CSKY_LINUX_NEXT_VERSION)
CSKY_LINUX_5_10_RISCV_VERSION	= 5daa9f6723047b48a7f07c9e1c9969593e7e9829
