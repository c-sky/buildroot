##############################################################################
#
# hw-c860
#
##############################################################################

HW_C860_INSTALL_IMAGES = YES

define HW_C860_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/hw/
	cp package/hw-c860/hw/* $(BINARIES_DIR)/hw/ -raf
	cp $(BINARIES_DIR)/../host/bin/dtc $(BINARIES_DIR)/hw/ -raf
endef

$(eval $(generic-package))
