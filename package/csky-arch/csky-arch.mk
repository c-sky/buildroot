###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION_4_9  = dc3d873b063f46bb06b40ab94428f2354a582ad7
CSKY_ARCH_VERSION_4_14 = 6f47980e3a87a46e58270bef6b5c83fbf14265a0
CSKY_ARCH_VERSION_4_19 = 76f9871c36fef18756a644f91c598626d194f17c

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
CSKY_LINUX_NEXT_VERSION	= f0bbf052ae463b3802f1c7ba36b36da2f54945f2
CSKY_LINUX_NEXT_RISCV_VERSION	= 9b8c946f3e338c1c876d6c563c473ba1a9e2704d
