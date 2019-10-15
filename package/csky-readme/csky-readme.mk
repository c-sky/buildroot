##############################################################################
#
# csky-readme
#
##############################################################################

CSKY_README_INSTALL_IMAGES = YES

CSKY_README_BD_VERSION=$(shell git log --pretty=oneline | head -1 | awk '{print $$1}')
CSKY_README_BD_CONFIG=$(shell grep BR2_DEFCONFIG $(CONFIG_DIR)/.config | awk -F/ '{print $$NF}'| sed 's/\"//g')
CSKY_README_CK860=$(shell grep BR2_ck860=y $(CONFIG_DIR)/.config)
CSKY_README_CK610=$(shell grep BR2_ck610=y $(CONFIG_DIR)/.config)

define CSKY_README_INSTALL_IMAGES_CMDS
	cp package/csky-readme/readme.txt $(BINARIES_DIR)/
	sed -i 's/<buildroot-job_id>/$(GITLAB_CI_JOB_ID)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-config>/$(CSKY_README_BD_CONFIG)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<buildroot-version>/$(CSKY_README_BD_VERSION)/g' $(BINARIES_DIR)/readme.txt
	sed -i 's/<kernel-version>/$(LINUX_VERSION)/g' $(BINARIES_DIR)/readme.txt
	if [ -n "$(CSKY_README_CK860)" ]; then \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -M virt -kernel Image -nographic -smp 2 -append "console=ttyS0,115200 rdinit=\/sbin\/init rootwait root=\/dev\/vda ro" -drive file=rootfs.ext2,format=raw,id=hd0 -device virtio-blk-device,drive=hd0/g' $(BINARIES_DIR)/readme.txt; \
	elif [ -n "$(CSKY_README_CK610)" ]; then \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv1 -M virt -kernel Image -nographic -append "console=ttyS0,115200 rdinit=\/sbin\/init rootwait root=\/dev\/vda ro" -drive file=rootfs.ext2,format=raw,id=hd0 -device virtio-blk-device,drive=hd0/g' $(BINARIES_DIR)/readme.txt; \
	else \
		sed -i 's/qemu_start_cmd/LD_LIBRARY_PATH=.\/host\/lib .\/host\/csky-qemu\/bin\/qemu-system-cskyv2 -M virt -kernel Image -nographic -append "console=ttyS0,115200 rdinit=\/sbin\/init rootwait root=\/dev\/vda ro" -drive file=rootfs.ext2,format=raw,id=hd0 -device virtio-blk-device,drive=hd0/g' $(BINARIES_DIR)/readme.txt; \
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

$(eval $(generic-package))
