##############################################################################
#
# csky-ci
#
##############################################################################

BR2_CSKY_CI_FPGA_BITMHZ="60"

ifeq ($(BR2_ck807),y)
BR2_CSKY_CI_FPGA_BITFILE="807.bit"
endif

ifeq ($(BR2_ck810),y)
BR2_CSKY_CI_FPGA_BITFILE="810.bit"
endif

ifeq ($(BR2_ck860),y)
BR2_CSKY_CI_FPGA_BITFILE="860.bit"
endif

ifeq ($(BR2_RISCV_64),y)
BR2_CSKY_CI_FPGA_BITFILE="910.bit"
BR2_CSKY_CI_FPGA_BITMHZ="30"
endif

define CSKY_CI_INSTALL_TARGET_CMDS
mkdir -p $(HOST_DIR)/csky-ci/
mkdir -p $(HOST_DIR)/csky-ci/parse_script/
mkdir -p $(TARGET_DIR)/usr/lib/csky-ci/
mkdir -p $(TARGET_DIR)/etc/init.ci/
cp -f ./package/csky-ci/generic/S90test $(TARGET_DIR)/etc/init.d/
cp -f ./package/csky-ci/generic/run_test.qemuv1 $(HOST_DIR)/csky-ci/run_test_qemuv1.sh
cp -f ./package/csky-ci/generic/run_test.qemuv2 $(HOST_DIR)/csky-ci/run_test_qemuv2.sh
cp -f ./package/csky-ci/generic/run_test.qemuv2_smp $(HOST_DIR)/csky-ci/run_test_qemuv2_smp.sh
cp -f ./package/csky-ci/generic/run_test.qemu_riscv64 $(HOST_DIR)/csky-ci/run_test_qemu_riscv64.sh
cp -f ./package/csky-ci/generic/run_test.fpga $(HOST_DIR)/csky-ci/run_test_fpga.sh
sed -i "s/NEW_S2C_BIT_NAME/$(BR2_CSKY_CI_FPGA_BITFILE)/" $(HOST_DIR)/csky-ci/run_test_fpga.sh
sed -i "s/NEW_S2C_BIT_MHZ/$(BR2_CSKY_CI_FPGA_BITMHZ)/" $(HOST_DIR)/csky-ci/run_test_fpga.sh
cp -f ./package/csky-ci/generic/run_test.chip $(HOST_DIR)/csky-ci/run_test_chip.sh
cp -f ./package/csky-ci/generic/test.sh $(TARGET_DIR)/etc/init.d/
cp -f ./package/csky-ci/generic/generic_analyze.sh $(HOST_DIR)/csky-ci/
cp -f ./package/csky-ci/generic/check_ssh_bg.sh $(HOST_DIR)/csky-ci/
chmod 755 $(HOST_DIR)/csky-ci/*.sh
chmod 755 $(TARGET_DIR)/etc/init.d/S90test
chmod 755 $(TARGET_DIR)/etc/init.d/test.sh
gcc -o $(HOST_DIR)/csky-ci/csky_serial ./package/csky-ci/generic/csky_serial.c -Wall
gcc -o $(HOST_DIR)/csky-ci/csky_switch ./package/csky-ci/generic/csky_switch.c -Wall

echo "killall test.sh > /dev/null 2>&1" >> $(TARGET_DIR)/etc/profile
echo "debugfs		/sys/kernel/debug  debugfs  defaults  0  0" >> $(TARGET_DIR)/etc/fstab
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

ifeq ($(BR2_PACKAGE_CSKY_CI),y)
OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_CP_SCRIPT
endif

$(eval $(generic-package))
