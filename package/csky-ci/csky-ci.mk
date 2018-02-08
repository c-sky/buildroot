#
##############################################################################
#
# csky ci
#
################################################################################

CSKY_CI_VERSION = 62bb76f223a7c7a436708191ebc1ab8a237861df
CSKY_CI_SITE = $(call github,riseandfall,csky-ci,$(CSKY_CI_VERSION))

define CSKY_CI_CONFIGURE_CMDS
echo CONFIG_CPU_CK610=$(BR2_ck610) > $(@D)/config
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
cp -f $(@D)/out/sh/* $(HOST_DIR)/csky-ci/
cp -f $(@D)/out/configs/* $(TARGET_DIR)/usr/lib/csky-ci/
cp -f $(@D)/out/S90test $(TARGET_DIR)/etc/init.d/
endef

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
define  HOST_GCC_FINAL_CSKY_TARBALL
        (cd $(HOST_DIR); \
         BUILDROOT_VERSION=$$(git log --pretty=oneline|head -1|awk '{print $$1}'); \
         BUILDROOT_CONFIG=$$(grep BR2_DEFCONFIG $(CONFIG_DIR)/.config|awk -F/ '{print $$NF}'|sed 's/\"//g'); \
         echo $$BUILDROOT_CONFIG > bin/.csky_bt_commit; \
         echo $$BUILDROOT_VERSION >> bin/.csky_bt_commit; \
         tar -czf $(BINARIES_DIR)/csky_toolchain_$${BUILDROOT_CONFIG}_$${BUILDROOT_VERSION}.tar.gz bin csky-buildroot* include lib lib64 libexec share usr; \
         cd - ;\
        )
endef
HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_CSKY_TARBALL
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
