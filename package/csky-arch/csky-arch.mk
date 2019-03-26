###############################################################################
#
# csky arch
#
################################################################################

CKTST_CSKY_ARCH_VERSION = 37a58d3b927709d3758fb96293dc8b4b0b497d46
CKTST_CSKY_ARCH_VERSION_4_19 = 2f8bb99ed441f64a3b59a7b0cf60b1a3abeee575
CKTST_CSKY_ARCH_VERSION_NEXT = 5876e3675788d0e476369650fd537aee9e429ce1

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
	$(APPLY_PATCHES) $(LINUX_DIR) $(CSKY_ARCH_DIR)/patch/ \*.patch || exit 1;
endef
LINUX_POST_EXTRACT_HOOKS += CSKY_ARCH_PREPARE_KERNEL

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
	cd $(LINUX_DIR)/; \
	mkdir -p tools/arch/csky/include/uapi/asm/; \
	cp tools/arch/arm/include/uapi/asm/mman.h tools/arch/csky/include/uapi/asm/mman.h; \
	cd -; \
	cd $(LINUX_DIR)/../; \
	cp -raf linux-$(LINUX_VERSION) a; \
	cd -; \
	fi
endef
LINUX_POST_EXTRACT_HOOKS += CSKY_LINUX_PREPARE_SRC_A

$(eval $(generic-package))
