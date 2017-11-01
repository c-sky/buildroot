################################################################################
#
# csky-qemu
#
################################################################################

CSKY_QEMU_VERSION = ce825f67bca4bbda1cd091e1bf6511fddaddb1a3
CSKY_QEMU_SITE = $(call github,c-sky,qemu,$(CSKY_QEMU_VERSION))

HOST_QEMU_DEPENDENCIES = host-pkgconf host-python host-zlib host-libglib2 host-pixman

define HOST_CSKY_QEMU_CONFIGURE_CMDS
		cd $(@D); \
		./configure \
		--target-list="cskyv1-softmmu cskyv2-softmmu" \
		--prefix="$(HOST_DIR)/csky-qemu"
endef

define HOST_CSKY_QEMU_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_CSKY_QEMU_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
	cp $(@D)/cskyv1-softmmu/qemu-system-cskyv1 $(HOST_DIR)/csky-qemu/bin
	cp $(@D)/cskyv2-softmmu/qemu-system-cskyv2 $(HOST_DIR)/csky-qemu/bin
endef

$(eval $(host-generic-package))
