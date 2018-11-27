#
##############################################################################
#
# csky ci
#
################################################################################

CSKY_CI_VERSION = 5fc370f3c12cc110205a0b422faddc0949a7a636
CSKY_CI_SITE = $(call github,c-sky,csky-ci,$(CSKY_CI_VERSION))

define CSKY_CI_CONFIGURE_CMDS
echo CONFIG_CPU_CK610=$(BR2_ck610) > $(@D)/config
echo CONFIG_CPU_CK807=$(BR2_ck807) >> $(@D)/config
echo CONFIG_CPU_CK810=$(BR2_ck810) >> $(@D)/config
echo CONFIG_CPU_CK860=$(BR2_ck860) >> $(@D)/config
echo CONFIG_FPGA=$(BR2_CSKY_FPGA) >> $(@D)/config
echo CONFIG_GLIBC=$(BR2_TOOLCHAIN_USES_GLIBC) >> $(@D)/config
echo CONFIG_QEMU=$(BR2_PACKAGE_HOST_CSKY_QEMU) >> $(@D)/config
echo CONFIG_TTY=$(BR2_TARGET_GENERIC_GETTY_PORT) >> $(@D)/config
endef

define CSKY_CI_BUILD_CMDS
make -C $(@D)
endef

define CSKY_CI_INSTALL_TARGET_CMDS
mkdir -p $(HOST_DIR)/csky-ci/
mkdir -p $(TARGET_DIR)/usr/lib/csky-ci/
cp -f $(@D)/out/csky_* $(HOST_DIR)/csky-ci/
cp -f $(@D)/out/sh/* $(HOST_DIR)/csky-ci/
cp -f $(@D)/out/configs/* $(TARGET_DIR)/usr/lib/csky-ci/
cp -f $(@D)/out/S90test $(TARGET_DIR)/etc/init.d/
cp -f $(@D)/out/test.sh $(TARGET_DIR)/etc/init.d/
endef

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
define CSKY_CI_TOOLCHAIN_TARBALL
        (cd $(HOST_DIR); \
         BUILDROOT_VERSION=$$(git log --pretty=oneline|head -1|awk '{print $$1}'); \
         BUILDROOT_CONFIG=$$(grep BR2_DEFCONFIG $(CONFIG_DIR)/.config|awk -F/ '{print $$NF}'|sed 's/\"//g'); \
         echo buildroot:$$BUILDROOT_CONFIG $$BUILDROOT_VERSION > csky_buildroot_version.txt; \
         echo linux-$(LINUX_VERSION) >> csky_buildroot_version.txt; \
         echo linux-csky-arch:$(CSKY_ARCH_VERSION) >> csky_buildroot_version.txt; \
         echo gcc:$(GCC_VERSION) >> csky_buildroot_version.txt; \
         echo binutils:$(BINUTILS_VERSION) >> csky_buildroot_version.txt; \
         echo glibc:$(GLIBC_VERSION) >> csky_buildroot_version.txt; \
         echo uclibc:$(UCLIBC_VERSION) >> csky_buildroot_version.txt; \
         echo gdb:$(GDB_VERSION) >> csky_buildroot_version.txt; \
         echo qemu:$(CSKY_QEMU_VERSION) >> csky_buildroot_version.txt; \
         echo Jtag:$(CSKY_DEBUG_VERSION) >> csky_buildroot_version.txt; \
         cp csky_buildroot_version.txt $(BINARIES_DIR)/; \
         tar -cJf $(BINARIES_DIR)/csky_toolchain_$${BUILDROOT_CONFIG}_$${BUILDROOT_VERSION}.tar.xz ./; \
         cd - ;\
        )
endef
LINUX_POST_EXTRACT_HOOKS += CSKY_CI_TOOLCHAIN_TARBALL
endif

ifeq ($(BR2_PACKAGE_LMBENCH),y)
define  LMBENCH_CP_SCRIPT
        (\
         cp $(@D)/bin/csky/lmbench $(TARGET_DIR)/usr/bin/;\
        )
endef
LMBENCH_POST_INSTALL_TARGET_HOOKS += LMBENCH_CP_SCRIPT
endif

$(eval $(generic-package))
