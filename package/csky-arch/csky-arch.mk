###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION = caf66103e71f2532513eb97c5a4c453b6d2dfdb3

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

define CSKY_LINUX_GENERATE_PATCH
	if [ ! -f $(LINUX_DIR)/.stamp_patched_csky ]; then \
	cd $(LINUX_DIR)/../; \
	mv linux-$(LINUX_VERSION) b; \
	rm $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch.xz; \
	diff -ruN a b > $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch; \
	xz -z $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch; \
	mv b linux-$(LINUX_VERSION); \
	rm -rf a; \
	cd -; \
	touch $(LINUX_DIR)/.stamp_patched_csky; \
	fi
endef
LINUX_POST_CONFIGURE_HOOKS += CSKY_LINUX_GENERATE_PATCH

ifeq ($(BR2_LINUX_KERNEL_USE_INTREE_DTS),y)
define CSKY_LINUX_COPY_DTS
	cp -f $(LINUX_DIR)/arch/csky/boot/dts/$(call qstrip,$(BR2_LINUX_KERNEL_INTREE_DTS_NAME)).dts $(BINARIES_DIR)
endef
LINUX_POST_CONFIGURE_HOOKS += CSKY_LINUX_COPY_DTS
else ifeq ($(BR2_LINUX_KERNEL_USE_CUSTOM_DTS),y)
define CSKY_LINUX_COPY_DTS
	cp -f $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_DTS_PATH)) $(BINARIES_DIR)
endef
LINUX_POST_CONFIGURE_HOOKS += CSKY_LINUX_COPY_DTS
endif

define CSKY_LINUX_PREPARE_SRC_A
	if [ ! -f $(LINUX_DIR)/.stamp_patched_csky ]; then \
	cd $(LINUX_DIR)/../; \
	cp -raf linux-$(LINUX_VERSION) a; \
	cd -; \
	fi
endef
LINUX_POST_EXTRACT_HOOKS += CSKY_LINUX_PREPARE_SRC_A

$(eval $(generic-package))
