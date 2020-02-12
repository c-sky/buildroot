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
	if [ $(GITLAB_CI_JOB_ID) ]; then \
	if [ ! -f $(BINARIES_DIR)/toolchain_$${BUILDROOT_CONFIG}_$${BUILDROOT_VERSION}.tar.xz ]; then \
	tar -cJf $(BINARIES_DIR)/toolchain_$${BUILDROOT_CONFIG}_$${BUILDROOT_VERSION}.tar.xz ./; \
	fi; \
	fi; \
	cd - ; \
	)
endef
CSKY_CI_ROOTFS_PRE_CMD_HOOKS += CSKY_TAR_HOST_TARBALL
