#
##############################################################################
#
# qemu-c910-enhanced
#
################################################################################

QEMU_C910_ENHANCED_SOURCE = csky-qemu-x86_64-Ubuntu-16.04-20191021-1758.tar.gz
QEMU_C910_ENHANCED_SITE = https://cop-image-prod.oss-cn-hangzhou.aliyuncs.com/resource/420257228264570880/1573609478873

define QEMU_C910_ENHANCED_INSTALL_TARGET_CMDS
	mkdir -p $(HOST_DIR)/csky-qemu
	cp -r $(@D)/* $(HOST_DIR)/csky-qemu
endef

$(eval $(generic-package))
