##############################################################################
#
# riscv-readme
#
##############################################################################

RISCV_README_INSTALL_IMAGES = YES

RISCV_README_BD_VERSION=$(shell git log --pretty=oneline | head -1 | awk '{print $$1}')
RISCV_README_BD_CONFIG=$(shell grep BR2_DEFCONFIG $(CONFIG_DIR)/.config | awk -F/ '{print $$NF}'| sed 's/\"//g')

define RISCV_README_INSTALL_IMAGES_CMDS
	@echo $(RISCV_README_BD_CONFIG)
	@echo $(RISCV_README_BD_VERSION)
	cp package/riscv-readme/readme.txt $(BINARIES_DIR)/
	sed -i 's/<buildroot-job_id>/$(GITLAB_CI_JOB_ID)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-config>/$(RISCV_README_BD_CONFIG)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-version>/$(RISCV_README_BD_VERSION)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<kernel-version>/$(LINUX_VERSION)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/bin\/qemu-system-riscv64 -M virt -kernel fw_jump.elf -device loader,file=Image,addr=0x80200000 -append \"rootwait root=/dev/ram0\" -nographic/g' $(BINARIES_DIR)/readme.txt; \
	echo buildroot:$(RISCV_README_BD_CONFIG) $(RISCV_README_BD_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo linux-$(LINUX_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo gcc:$(GCC_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo binutils:$(BINUTILS_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo glibc:$(GLIBC_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo uclibc:$(UCLIBC_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo gdb:$(GDB_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo qemu:$(QEMU_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	cp $(BINARIES_DIR)/readme.txt $(HOST_DIR)/;
endef

$(eval $(generic-package))
