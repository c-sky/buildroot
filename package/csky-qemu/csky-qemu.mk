################################################################################
#
# csky-qemu
#
################################################################################

ifeq ($(BR2_CSKY_QEMU_GERRIT), y)
CSKY_QEMU_VERSION = c1b8e693b1dcc9ae865df6b89626f03894b15ca9
CSKY_QEMU_SITE = "ssh://${GITUSER}@192.168.0.78:29418/tools/qemu"
CSKY_QEMU_SITE_METHOD = git
else
CSKY_QEMU_VERSION = 943f291cbaed0744681f51a3632f8ecb8cfbd243
CSKY_QEMU_SITE = $(call github,c-sky,qemu,$(CSKY_QEMU_VERSION))
endif

HOST_CSKY_QEMU_DEPENDENCIES = host-pkgconf host-python host-zlib \
			      host-libglib2 host-pixman host-dtc

HOST_CSKY_QEMU_OPTS += --enable-system --enable-fdt

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

$(eval $(host-generic-package))
