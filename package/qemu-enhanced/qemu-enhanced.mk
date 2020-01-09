#
##############################################################################
#
# qemu-enhanced
#
################################################################################

QEMU_ENHANCED_SOURCE = csky-qemu-x86_64-Ubuntu-16.04-20200107-1024.tar.gz
QEMU_ENHANCED_SITE = https://cop-image-prod.oss-cn-hangzhou.aliyuncs.com/resource/420262990181302272/1578365933510

define QEMU_ENHANCED_INSTALL_TARGET_CMDS
	mkdir -p $(HOST_DIR)/csky-qemu
	cp -r $(@D)/* $(HOST_DIR)/csky-qemu
	rm -f $(HOST_DIR)/csky-qemu/share/qemu/edk2-aarch64-code.fd
	rm -f $(HOST_DIR)/csky-qemu/share/qemu/edk2-arm-code.fd
	rm -f $(HOST_DIR)/csky-qemu/share/qemu/edk2-arm-vars.fd
endef

$(eval $(generic-package))
