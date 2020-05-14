##############################################################################
#
# hw-c810
#
##############################################################################

HW_C810_INSTALL_IMAGES = YES

define HW_C810_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/hw/
	cp package/hw-c810/hw/* $(BINARIES_DIR)/hw/ -raf
	cp $(BINARIES_DIR)/../host/bin/dtc $(BINARIES_DIR)/hw/ -raf

        for dts_file in $(BINARIES_DIR)/hw/*.dts.txt; \
        do \
                echo "filename is $$dts_file"; \
                sed '1 i//KERNEL-TAG:$(BR2_LINUX_KERNEL_VERSION)' -i $$dts_file; \
        done
endef

$(eval $(generic-package))
