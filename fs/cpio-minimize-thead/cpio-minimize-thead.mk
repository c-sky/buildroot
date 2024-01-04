define ROOTFS_CPIO_MINIMIZE_THEAD
	rm -rf $(TARGET_DIR)/usr/lib/ltp*
	rm -rf $(TARGET_DIR)/etc/init.d/S50sshd
	rm -rf $(TARGET_DIR)/etc/init.ci/ltp_run
	rm -rf $(TARGET_DIR)/ci/go
	rm -rf $(TARGET_DIR)/etc/init.ci/go_run
	rm -rf $(TARGET_DIR)/ci/openjdk
	rm -rf $(TARGET_DIR)/etc/init.ci/openjdk_run
	rm -rf $(TARGET_DIR)/ci
	rm -rf $(TARGET_DIR)/ltp
	rm -rf $(TARGET_DIR)/usr/lib/jvm
	rm -rf $(TARGET_DIR)/usr/bin/litmus
	rm -rf $(TARGET_DIR)/usr/bin/atomicbench
	rm -rf $(TARGET_DIR)/usr/bin/circustent
	rm -rf $(TARGET_DIR)/lib/modules/5.10.4/kernel/klitmus
endef

ifeq ($(BR2_PACKAGE_CSKY_CI),y)
ROOTFS_CPIO_PRE_GEN_HOOKS += ROOTFS_CPIO_MINIMIZE_THEAD
ROOTFS_TAR_PRE_GEN_HOOKS  += ROOTFS_CPIO_MINIMIZE_THEAD
endif
