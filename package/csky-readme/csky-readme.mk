##############################################################################
#
# csky-readme
#
##############################################################################

BUILDROOT_VERSION=$(shell git log --pretty=oneline | head -1 | awk '{print $$1}')
BUILDROOT_CONFIG=$(shell grep BR2_DEFCONFIG $(CONFIG_DIR)/.config | awk -F/ '{print $$NF}'| sed 's/\"//g')
CSKY_README_CK860=$(shell grep BR2_ck860=y $(CONFIG_DIR)/.config)

define CSKY_README_INSTALL_TARGET_CMDS
	@echo $(BUILDROOT_CONFIG)
	@echo $(BUILDROOT_VERSION)
	cp package/csky-readme/readme.txt $(BINARIES_DIR)/
	sed -i 's/<buildroot-config>/$(BUILDROOT_CONFIG)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-version>/$(BUILDROOT_VERSION)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<kernel-version>/$(LINUX_VERSION)/g' $(BINARIES_DIR)/readme.txt
	if [ -n "$(CSKY_README_CK860)" ]; then \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -M mp860 -smp 2 -kernel vmlinux -dtb qemu_smp.dtb -nographic/g' $(BINARIES_DIR)/readme.txt; \
	else \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -machine virt -kernel vmlinux -dtb qemu.dtb -nographic/g' $(BINARIES_DIR)/readme.txt; \
	fi
endef

$(eval $(generic-package))
