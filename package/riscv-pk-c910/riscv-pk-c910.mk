################################################################################
#
# riscv-pk
#
################################################################################

RISCV_PK_C910_VERSION = d07f5d0d978faa6f60d3256fdf901e19c5036f75
RISCV_PK_C910_SOURCE = riscv-pk-c910-$(RISCV_PK_C910_VERSION).tar.gz
RISCV_PK_C910_SITE = $(call github,c-sky,riscv-pk,$(RISCV_PK_C910_VERSION))

RISCV_PK_C910_LICENSE = BSD-3-Clause
RISCV_PK_C910_LICENSE_FILES = LICENSE
RISCV_PK_C910_SUBDIR = build
RISCV_PK_C910_INSTALL_IMAGES = YES

define RISCV_PK_C910_CONFIGURE_CMDS
	mkdir -p $(@D)/build
	(cd $(@D)/build; \
		$(TARGET_CONFIGURE_OPTS) ../configure \
		--host=$(GNU_TARGET_NAME) \
		--with-payload=/dev/null \
	)
endef

define RISCV_PK_C910_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build bbl
endef

define RISCV_PK_C910_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/bbl $(BINARIES_DIR)/c910/bbl
endef

$(eval $(generic-package))
