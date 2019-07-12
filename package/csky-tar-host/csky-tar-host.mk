##############################################################################
#
# csky tar host
#
##############################################################################

define CSKY_TAR_HOST_TARBALL
	( \
	cd $(HOST_DIR); \
	BUILDROOT_VERSION=$$(git log --pretty=oneline|head -1|awk '{print $$1}'); \
	BUILDROOT_CONFIG=$$(grep BR2_DEFCONFIG $(CONFIG_DIR)/.config|awk -F/ '{print $$NF}'|sed 's/\"//g'); \
	if [ -f ./bin/qemu-img ]; then \
		mkdir ./csky-qemu/bin -p; cp ./bin/qemu-system-* ./csky-qemu/bin/; \
	fi; \
	tar -cJf $(BINARIES_DIR)/csky_toolchain_$${BUILDROOT_CONFIG}_$${BUILDROOT_VERSION}.tar.xz ./; \
	cd - ; \
	)
endef
CSKY_CI_ROOTFS_PRE_CMD_HOOKS += CSKY_TAR_HOST_TARBALL
