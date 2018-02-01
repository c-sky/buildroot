#
##############################################################################
#
# csky test
#
################################################################################

CSKY_TEST_VERSION = 8af57677d955eabace81667010dc3dc408db3179
CSKY_TEST_SITE = $(call github,riseandfall,csky-test,$(CSKY_TEST_VERSION))
ifeq ($(BR2_CSKY_TEST_GDB_FILE),"")
CSKY_TEST_CP_GDBINIT =
else ifeq ($(BR2_CSKY_TEST_GDB_FILE),)
CSKY_TEST_CP_GDBINIT =
else
CSKY_TEST_CP_GDBINIT = cp -f $(BR2_CSKY_TEST_GDB_FILE) $(BINARIES_DIR)/.gdbinit
endif

define CSKY_TEST_CONFIGURE_CMDS
echo CONFIG_CPU=$(BR2_CSKY_TEST_CPU) > $(@D)/config
echo CONFIG_LIBC=$(BR2_CSKY_TEST_LIBC) >> $(@D)/config
echo CONFIG_QEMU=$(BR2_CSKY_TEST_QEMU) >> $(@D)/config
echo CONFIG_GDB=$(BR2_CSKY_TEST_GDB_FILE) >> $(@D)/config
echo CONFIG_TTY=$(BR2_TARGET_GENERIC_GETTY_PORT) >> $(@D)/config
echo CONFIG_NFS=$(BR2_CSKY_TEST_NFS_PATH) >> $(@D)/config
echo CONFIG_LTP=$(BR2_PACKAGE_CSKY_TEST_LTP) >> $(@D)/config
echo CONFIG_LMBENCH=$(BR2_PACKAGE_CSKY_TEST_LMBENCH) >> $(@D)/config
echo CONFIG_DHRYSTONE=$(BR2_PACKAGE_CSKY_TEST_DHRYSTONE) >> $(@D)/config
echo CONFIG_WHETSTONE=$(BR2_PACKAGE_CSKY_TEST_WHETSTONE) >> $(@D)/config
endef

define CSKY_TEST_BUILD_CMDS
make -C $(@D)
endef

define CSKY_TEST_INSTALL_TARGET_CMDS
mkdir -p $(HOST_DIR)/csky-test/
mkdir -p $(TARGET_DIR)/usr/lib/csky-test/
cp -f $(@D)/out/sh/* $(HOST_DIR)/csky-test/
cp -f $(@D)/out/configs/* $(TARGET_DIR)/usr/lib/csky-test/
cp -f $(@D)/out/S90test $(TARGET_DIR)/etc/init.d/
$(CSKY_TEST_CP_GDBINIT)
endef

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
define  HOST_GCC_FINAL_CSKY_TARBALL
        (cd $(HOST_DIR); \
         BUILDROOT_VERSION=$$(git log --pretty=oneline|head -1|awk '{print $$1}'); \
         BUILDROOT_CONFIG=$$(grep BR2_DEFCONFIG $(CONFIG_DIR)/.config|awk -F/ '{print $$NF}'|sed 's/\"//g'); \
         echo $$BUILDROOT_VERSION; \
         echo $$BUILDROOT_CONFIG; \
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
         echo cp $(@D)/bin/csky/lmbench $(TARGET_DIR)/usr/bin/;\
        )
endef
LMBENCH_POST_INSTALL_TARGET_HOOKS += LMBENCH_CP_SCRIPT
endif

$(eval $(generic-package))
$(eval $(host-generic-package))
