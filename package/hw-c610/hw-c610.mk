##############################################################################
#
# hw-c610
#
##############################################################################

HW_C610_INSTALL_IMAGES = YES

define HW_C610_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/hw/
	cp package/hw-c610/hw/* $(BINARIES_DIR)/hw/ -raf
endef

$(eval $(generic-package))
