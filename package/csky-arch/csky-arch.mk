###############################################################################
#
# csky arch
#
################################################################################

CKTST_CSKY_ARCH_VERSION = aa2debf242108ff33583412fcf6695e024ded243
CKTST_CSKY_ARCH_VERSION_4_19 = 11adc367f52189a1d7f78bb7279a1210c232f199
CKTST_CSKY_ARCH_VERSION_NEXT = cd51a044aa0de38fc67a2990ee972d440fbb5b31

CSKY_LINUX_NEXT_VERSION = $(call qstrip,$(CKTST_CSKY_ARCH_VERSION_NEXT))

ifeq ($(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_19), y)
CSKY_ARCH_VERSION = $(CKTST_CSKY_ARCH_VERSION_4_19)
else
CSKY_ARCH_VERSION = $(CKTST_CSKY_ARCH_VERSION)
endif

ifneq ($(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_VERSION), "")
CSKY_ARCH_VERSION = $(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_VERSION)
endif

ifeq ($(BR2_CSKY_GERRIT_REPO),y)
CSKY_ARCH_SITE = ssh://${GITUSER}@192.168.0.78:29418/os/linux-csky
CSKY_ARCH_SITE_METHOD = git
else
CSKY_ARCH_SITE = $(call gitlab,c-sky,csky-linux,$(CSKY_ARCH_VERSION))
endif

ifeq ($(BR2_PACKAGE_CSKY_ARCH), y)
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

define CSKY_LINUX_PREPARE_SRC_A
	if [ ! -f $(LINUX_DIR)/.stamp_patched_csky ]; then \
	cd $(LINUX_DIR)/../; \
	rm -rf a; \
	cp -raf linux-$(LINUX_VERSION) a; \
	cd -; \
	fi
endef
LINUX_POST_EXTRACT_HOOKS += CSKY_LINUX_PREPARE_SRC_A
LINUX_POST_EXTRACT_HOOKS += CSKY_ARCH_PREPARE_KERNEL

define CSKY_LINUX_GENERATE_PATCH
	if [ ! -f $(LINUX_DIR)/.stamp_patched_csky ]; then \
	cd $(LINUX_DIR)/../; \
	rm -rf b; \
	cp -raf linux-$(LINUX_VERSION) b; \
	rm $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch.xz; \
	diff -ruN a b > $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch; \
	xz -z $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch; \
	cd -; \
	touch $(LINUX_DIR)/.stamp_patched_csky; \
	fi
endef
LINUX_POST_CONFIGURE_HOOKS += CSKY_LINUX_GENERATE_PATCH

endif

# Prepare linux headers
ifeq ($(BR2_PACKAGE_LINUX_HEADERS)$(BR2_PACKAGE_CSKY_ARCH), yy)
LINUX_HEADERS_DEPENDENCIES += csky-arch
define LINUX_HEADERS_CSKY_ARCH
	cp $(CSKY_ARCH_DIR)/arch/csky $(LINUX_HEADERS_DIR)/arch -raf
endef
LINUX_HEADERS_POST_PATCH_HOOKS += LINUX_HEADERS_CSKY_ARCH
endif

# Install dts to images
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

$(eval $(generic-package))
