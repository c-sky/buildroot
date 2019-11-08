##############################################################################
#
# csky-ci
#
##############################################################################

CSKY_CI_VERSION = 7912c01f4378d6774fb254111355d772148d7aaa
CSKY_CI_SITE = $(call github,c-sky,csky-ci,$(CSKY_CI_VERSION))

ifeq ($(BR2_ck860),y)
BR2_CSKY_CI_FPGA=y
BR2_CSKY_CI_FPGA_BITFILE="e3_DH_860_no_vdsp_60M_190814.bit"
endif

ifeq ($(BR2_RISCV_64),y)
BR2_CSKY_CI_FPGA=y
BR2_CSKY_CI_FPGA_BITFILE="C960M_191025_debug_label1017_60MHz.bit"
endif

define CSKY_CI_CONFIGURE_CMDS
echo CONFIG_CPU_CK610=$(BR2_ck610) > $(@D)/config
echo CONFIG_CPU_CK807=$(BR2_ck807) >> $(@D)/config
echo CONFIG_CPU_CK810=$(BR2_ck810) >> $(@D)/config
echo CONFIG_CPU_CK860=$(BR2_ck860) >> $(@D)/config
echo CONFIG_CPU_CK960=$(BR2_RISCV_64) >> $(@D)/config
echo CONFIG_FPGA=$(BR2_CSKY_CI_FPGA) >> $(@D)/config
echo CONFIG_FPGA_BITFILE=$(BR2_CSKY_CI_FPGA_BITFILE) >> $(@D)/config
echo CONFIG_QEMU=$(BR2_PACKAGE_HOST_QEMU) >> $(@D)/config
endef

define CSKY_CI_BUILD_CMDS
make -C $(@D)
endef

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

define OPENSSH_CP_SCRIPT
	mkdir -p $(HOST_DIR)/csky-ci/
	cp -f ./package/csky-ci/ssh_parse $(HOST_DIR)/csky-ci/parse_script/
	cp /etc/ssh/ssh_host_* $(TARGET_DIR)/etc/ssh | `exit 0`
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

ifeq ($(BR2_PACKAGE_LMBENCH),y)
define  LMBENCH_CP_SCRIPT
        (\
         cp $(@D)/bin/csky/lmbench $(TARGET_DIR)/usr/bin/;\
        )
endef
LMBENCH_POST_INSTALL_TARGET_HOOKS += LMBENCH_CP_SCRIPT
endif

$(eval $(generic-package))
