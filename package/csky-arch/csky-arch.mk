###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION = bf39083c97f98c423e93b16e6bcfc64a5ff5cb7d

ifneq ($(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_VERSION), "")
CSKY_ARCH_VERSION = $(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_VERSION)
endif

ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_GITHUB),y)
CSKY_ARCH_SITE = $(call github,c-sky,csky-linux,$(CSKY_ARCH_VERSION))
else
CSKY_ARCH_SITE = $(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_GIT_URL)
CSKY_ARCH_SITE_METHOD = git
endif

ifeq ($(BR2_PACKAGE_LINUX_HEADERS)$(BR2_PACKAGE_CSKY_ARCH), yy)
LINUX_HEADERS_DEPENDENCIES += csky-arch
define LINUX_HEADERS_CSKY_ARCH
	cp $(CSKY_ARCH_DIR)/arch/csky $(LINUX_HEADERS_DIR)/arch -raf
endef
LINUX_HEADERS_POST_PATCH_HOOKS += LINUX_HEADERS_CSKY_ARCH
endif

define CSKY_ARCH_VERSION_ADD
	echo "CFLAGS_cpu-probe.o := -DCSKY_ARCH_VERSION=\"\\\"$(CSKY_ARCH_VERSION)\\\"\"" >> $(CSKY_ARCH_DIR)/arch/csky/kernel/Makefile
endef
CSKY_ARCH_POST_EXTRACT_HOOKS += CSKY_ARCH_VERSION_ADD

define CSKY_LINUX_TAR_BALL
	rm -f $(BINARIES_DIR)/linux-$(LINUX_VERSION).tar.gz
	cd $(LINUX_DIR)/../; \
	tar cJf $(BINARIES_DIR)/linux-$(LINUX_VERSION).tar.xz linux-$(LINUX_VERSION); \
	cd -
endef
LINUX_POST_CONFIGURE_HOOKS += CSKY_LINUX_TAR_BALL

$(eval $(generic-package))
