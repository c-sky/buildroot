##############################################################################
#
# csky-ci
#
##############################################################################

CSKY_CI_VERSION = 68166bc37221914579f60947d39ac79f0c044669
CSKY_CI_SITE = $(call github,c-sky,csky-ci,$(CSKY_CI_VERSION))

define CSKY_CI_CONFIGURE_CMDS
echo CONFIG_CPU_CK610=$(BR2_ck610) > $(@D)/config
echo CONFIG_CPU_CK807=$(BR2_ck807) >> $(@D)/config
echo CONFIG_CPU_CK810=$(BR2_ck810) >> $(@D)/config
echo CONFIG_CPU_CK860=$(BR2_ck860) >> $(@D)/config
echo CONFIG_FPGA=$(BR2_CSKY_FPGA) >> $(@D)/config
echo CONFIG_FPGA_BITFILE=$(BR2_CSKY_FPGA_BITFILE) >> $(@D)/config
echo CONFIG_FPGA_DDRINIT=$(BR2_CSKY_FPGA_DDRINIT) >> $(@D)/config
echo CONFIG_QEMU=$(BR2_CSKY_QEMU) >> $(@D)/config
endef

define CSKY_CI_BUILD_CMDS
make -C $(@D)
endef

#cp -f $(@D)/out/sh/* $(HOST_DIR)/csky-ci/
#cp -f $(@D)/out/configs/* $(TARGET_DIR)/usr/lib/csky-ci/

define CSKY_CI_INSTALL_TARGET_CMDS
mkdir -p $(HOST_DIR)/csky-ci/
mkdir -p $(HOST_DIR)/csky-ci/parse_script/
mkdir -p $(TARGET_DIR)/usr/lib/csky-ci/
mkdir -p $(TARGET_DIR)/etc/init.ci/
cp -f $(@D)/out/csky_* $(HOST_DIR)/csky-ci/
cp -f $(@D)/out/S90test $(TARGET_DIR)/etc/init.d/
cp -f $(@D)/out/test.sh $(TARGET_DIR)/etc/init.d/
echo "killall test.sh > /dev/null 2>&1" >> $(TARGET_DIR)/etc/profile
echo "debugfs		/sys/kernel/debug  debugfs  defaults  0  0" >> $(TARGET_DIR)/etc/fstab
cp -f $(@D)/out/sh/* $(HOST_DIR)/csky-ci/
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
HOST_FAKEROOT_POST_EXTRACT_HOOKS += CSKY_CI_TOOLCHAIN_TARBALL
endif

ifeq ($(BR2_CSKY_CI_SSH),y)
define OPENSSH_CP_SCRIPT
	mkdir -p $(HOST_DIR)/csky-ci/
	cp -f ./package/csky-ci/ssh_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod 755 $(HOST_DIR)/csky-ci/parse_script/ssh_parse
	cp -f package/csky-ci/S50sshd $(TARGET_DIR)/etc/init.d/
	mkdir -p $(TARGET_DIR)/root/.ssh
	if [ -f ~/.ssh/id_rsa.pub ]; then \
	  cp -f ~/.ssh/id_rsa.pub $(TARGET_DIR)/root/.ssh/authorized_keys; \
	else \
	  cp -f package/csky-ci/authorized_keys $(TARGET_DIR)/root/.ssh/authorized_keys; \
	fi
endef
OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_CP_SCRIPT
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
