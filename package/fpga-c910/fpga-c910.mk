##############################################################################
#
# fpga-c910
#
##############################################################################

define BR2_FPGA_C910_COPY
	mkdir -p $(BINARIES_DIR)/hw/
	cp package/fpga-c910/debug_model/* $(BINARIES_DIR)/hw/ -raf
endef
LINUX_POST_INSTALL_IMAGES_HOOKS += BR2_FPGA_C910_COPY
