##############################################################################
#
# csky-readme
#
##############################################################################

CSKY_README_BD_VERSION=$(shell git log --pretty=oneline | head -1 | awk '{print $$1}')
CSKY_README_BD_CONFIG=$(shell grep BR2_DEFCONFIG $(CONFIG_DIR)/.config | awk -F/ '{print $$NF}'| sed 's/\"//g')
CSKY_README_CK860=$(shell grep BR2_ck860=y $(CONFIG_DIR)/.config)

define CSKY_README_SETUP 
	@echo $(CSKY_README_BD_CONFIG)
	@echo $(CSKY_README_BD_VERSION)
	@echo $(CSKY_README_JOB_ID)
	cp package/csky-readme/readme.txt $(BINARIES_DIR)/
	sed -i 's/<buildroot-job_id>/$(CSKY_README_JOB_ID)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-config>/$(CSKY_README_BD_CONFIG)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-version>/$(CSKY_README_BD_VERSION)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<kernel-version>/$(LINUX_VERSION)/g' $(BINARIES_DIR)/readme.txt
	if [ -n "$(CSKY_README_CK860)" ]; then \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -M virt -cpu ck860 -smp 2 -kernel vmlinux -nographic/g' $(BINARIES_DIR)/readme.txt; \
	else \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -M virt -kernel vmlinux -nographic/g' $(BINARIES_DIR)/readme.txt; \
	fi; \
	echo buildroot:$(CSKY_README_BD_CONFIG) $(CSKY_README_BD_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo linux-$(LINUX_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo linux-csky-arch:$(CSKY_ARCH_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo gcc:$(GCC_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo binutils:$(BINUTILS_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo glibc:$(GLIBC_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo uclibc:$(UCLIBC_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo gdb:$(GDB_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo qemu:$(QEMU_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	echo Jtag:$(CSKY_DEBUG_VERSION) >> $(BINARIES_DIR)/readme.txt; \
	cp $(BINARIES_DIR)/readme.txt $(HOST_DIR)/;
endef
LINUX_POST_INSTALL_IMAGES_HOOKS += CSKY_README_SETUP
