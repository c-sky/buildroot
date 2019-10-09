###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION_4_9  = 416d82784a1af3ce68e64f68ca713a1fb99cf76f
CSKY_ARCH_VERSION_4_14 = f7b4f0898908f2b6a9ee1ecd821bde7a0d4a4ee7
CSKY_ARCH_VERSION_4_19 = 9986f9decb1f154d445fbf728034831723b91a5e

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
	cp -raf $(CSKY_ARCH_DIR)/arch/csky $(LINUX_DIR)/arch/
	if [ -d $(CSKY_ARCH_DIR)/arch-csky-drivers ]; then \
		cp -raf $(CSKY_ARCH_DIR)/arch-csky-drivers $(LINUX_DIR)/; \
	fi
	if [ -d $(CSKY_ARCH_DIR)/drivers ]; then \
		cp -raf $(CSKY_ARCH_DIR)/drivers $(LINUX_DIR)/arch-csky-drivers; \
	fi
	awk '/:= drivers/{print $$0,"arch-csky-drivers/";next}{print $$0}' \
		$(LINUX_DIR)/Makefile 1<>$(LINUX_DIR)/Makefile
	cd $(LINUX_DIR)/; \
	mkdir -p tools/arch/csky/include/uapi/asm/; \
	cp tools/arch/arm/include/uapi/asm/mman.h tools/arch/csky/include/uapi/asm/mman.h; \
	echo "CFLAGS_cpu-probe.o := -DCSKY_ARCH_VERSION=\"\\\"$(CSKY_ARCH_VERSION)\\\"\"" >> arch/csky/kernel/Makefile; \
	cd -;
	$(APPLY_PATCHES) $(LINUX_DIR) $(CSKY_ARCH_DIR)/patch/ \*.patch || exit 1;
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
