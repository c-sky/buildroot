################################################################################
#
# csky-qemu
#
################################################################################

CSKY_QEMU_VERSION = 48bed585a5873fc18851adf5ecd9917118f56d06
ifeq ($(BR2_CSKY_QEMU_GERRIT), y)
CSKY_QEMU_SITE = "ssh://${GITUSER}@192.168.0.78:29418/tools/qemu"
CSKY_QEMU_SITE_METHOD = git
else
CSKY_QEMU_SITE = $(call gitlab,guoren83,qemu,$(CSKY_QEMU_VERSION))
endif

HOST_CSKY_QEMU_DEPENDENCIES = host-pkgconf host-python host-zlib \
			      host-libglib2 host-pixman host-dtc

HOST_CSKY_QEMU_OPTS += --enable-system --enable-fdt --disable-gcrypt

define HOST_CSKY_QEMU_CONFIGURE_CMDS
	cd $(@D); $(HOST_CONFIGURE_OPTS) CPP="$(HOSTCC) -E" \
	./configure \
	--target-list="cskyv1-softmmu cskyv2-softmmu" \
	--prefix="$(HOST_DIR)/csky-qemu" \
	--interp-prefix=$(STAGING_DIR) \
	--cc="$(HOSTCC)" \
	--host-cc="$(HOSTCC)" \
	--python=$(HOST_DIR)/bin/python2 \
	--extra-cflags="$(HOST_CFLAGS)" \
	--extra-ldflags="$(HOST_LDFLAGS)" \
	$(HOST_CSKY_QEMU_OPTS)
endef

define HOST_CSKY_QEMU_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_CSKY_QEMU_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
	cp $(@D)/cskyv1-softmmu/qemu-system-cskyv1 $(HOST_DIR)/csky-qemu/bin
	cp $(@D)/cskyv2-softmmu/qemu-system-cskyv2 $(HOST_DIR)/csky-qemu/bin
endef

define HOST_CSKY_QEMU_APPLY_PATCHES
	if test -d package/csky-qemu/$(CSKY_QEMU_VERSION); then \
		$(APPLY_PATCHES) $(@D) $${patchdir} \*.patch || exit 1; \
	fi
endef

$(eval $(host-generic-package))
