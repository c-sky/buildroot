###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION = a5dd7acc8992d7d8a826a0b3551e78dafddec306

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

define CSKY_ARCH_TARBALL
	cp $(BR2_DL_DIR)/csky-arch-$(CSKY_ARCH_VERSION).tar.gz $(BINARIES_DIR)/
endef
CSKY_ARCH_POST_INSTALL_TARGET_HOOKS += CSKY_ARCH_TARBALL

define CSKY_ARCH_VERSION_ADD
	echo "CFLAGS_cpu-probe.o := -DCSKY_ARCH_VERSION=\"\\\"$(CSKY_ARCH_VERSION)\\\"\"" >> $(CSKY_ARCH_DIR)/arch/csky/kernel/Makefile
endef
CSKY_ARCH_POST_EXTRACT_HOOKS += CSKY_ARCH_VERSION_ADD

$(eval $(generic-package))
