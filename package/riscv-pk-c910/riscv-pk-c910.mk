################################################################################
#
# riscv-pk
#
################################################################################

RISCV_PK_C910_VERSION = 0c29c7db3457cadeb85b289858659e522d7b1eb6
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
	mv $(@D)/build/bbl $(@D)/build/bbl_3G
	sed -i 's/0xc0000000/0x00000000/g' $(@D)/bbl/bbl.lds
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build bbl
	mv $(@D)/build/bbl $(@D)/build/bbl_0G
endef

define RISCV_PK_C910_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/bbl_3G $(BINARIES_DIR)/hw/bbl_3G.elf
	$(INSTALL) -D -m 0755 $(@D)/build/bbl_0G $(BINARIES_DIR)/hw/bbl_0G.elf
	$(TARGET_OBJCOPY) -O binary $(@D)/build/bbl_3G $(BINARIES_DIR)/hw/bbl_3G.bin
	$(TARGET_OBJCOPY) -O binary $(@D)/build/bbl_0G $(BINARIES_DIR)/hw/bbl_0G.bin
endef

$(eval $(generic-package))
