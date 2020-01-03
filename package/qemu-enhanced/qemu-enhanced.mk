#
##############################################################################
#
# qemu-enhanced
#
################################################################################

QEMU_ENHANCED_SOURCE = csky-qemu-x86_64-Ubuntu-16.04-20200104-1737.tar.gz
QEMU_ENHANCED_SITE = https://cop-image-prod.oss-cn-hangzhou.aliyuncs.com/resource/420262990181302272/1578144260651

define QEMU_ENHANCED_INSTALL_TARGET_CMDS
	mkdir -p $(HOST_DIR)/csky-qemu
	cp -r $(@D)/* $(HOST_DIR)/csky-qemu
endef

$(eval $(generic-package))
