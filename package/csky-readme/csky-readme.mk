##############################################################################
#
# csky-readme
#
##############################################################################

CSKY_README_BD_VERSION=$(shell git log --pretty=oneline | head -1 | awk '{print $$1}')
CSKY_README_BD_CONFIG=$(shell grep BR2_DEFCONFIG $(CONFIG_DIR)/.config | awk -F/ '{print $$NF}'| sed 's/\"//g')
CSKY_README_CK860=$(shell grep BR2_ck860=y $(CONFIG_DIR)/.config)

define CSKY_README_INSTALL_TARGET_CMDS
	@echo $(CSKY_README_BD_CONFIG)
	@echo $(CSKY_README_BD_VERSION)
	@echo $(CSKY_README_JOB_ID)
	cp package/csky-readme/readme.txt $(BINARIES_DIR)/
	sed -i 's/<buildroot-job_id>/$(CSKY_README_JOB_ID)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-config>/$(CSKY_README_BD_CONFIG)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-version>/$(CSKY_README_BD_VERSION)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<kernel-version>/$(LINUX_VERSION)/g' $(BINARIES_DIR)/readme.txt
	if [ -n "$(CSKY_README_CK860)" ]; then \
		sed -i 's/qemu_what/qemu_smp/g' $(BINARIES_DIR)/readme.txt; \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -M virt -cpu ck860 -smp 2 -kernel vmlinux -nographic/g' $(BINARIES_DIR)/readme.txt; \
	else \
		sed -i 's/qemu_what/qemu/g' $(BINARIES_DIR)/readme.txt; \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -M virt -kernel vmlinux -nographic/g' $(BINARIES_DIR)/readme.txt; \
	fi
endef

$(eval $(generic-package))
