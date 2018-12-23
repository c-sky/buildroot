##############################################################################
#
# csky-readme
#
##############################################################################

BUILDROOT_VERSION=$(shell git log --pretty=oneline | head -1 | awk '{print $$1}')
BUILDROOT_CONFIG=$(shell grep BR2_DEFCONFIG $(CONFIG_DIR)/.config | awk -F/ '{print $$NF}'| sed 's/\"//g')

define CSKY_README_INSTALL_TARGET_CMDS
	echo $(BUILDROOT_CONFIG)
	echo $(BUILDROOT_VERSION)
	cp package/csky-readme/readme.txt $(BINARIES_DIR)/
	sed -i 's/<buildroot-config>/$(BUILDROOT_CONFIG)/g' $(BINARIES_DIR)/readme.txt; \
	sed -i 's/<buildroot-version>/$(BUILDROOT_VERSION)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<kernel-version>/$(LINUX_VERSION)/g' $(BINARIES_DIR)/readme.txt
endef

$(eval $(generic-package))
