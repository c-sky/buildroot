################################################################################
#
# opensbi
#
################################################################################

OPENSBI_C910_VERSION = c0849cd731fca884c939e6a1a699a853231292a2
OPENSBI_C910_SOURCE = opensbi-c910-$(OPENSBI_C910_VERSION).tar.gz
OPENSBI_C910_SITE = $(call github,riscv,opensbi,$(OPENSBI_C910_VERSION))
OPENSBI_C910_INSTALL_TARGET = NO
OPENSBI_C910_INSTALL_STAGING = YES

OPENSBI_C910_MAKE_ENV = \
	CROSS_COMPILE=$(TARGET_CROSS)

OPENSBI_C910_PLAT = $(call qstrip,$(BR2_TARGET_OPENSBI_C910_PLAT))
ifneq ($(OPENSBI_C910_PLAT),)
OPENSBI_C910_MAKE_ENV += PLATFORM=$(OPENSBI_C910_PLAT)
endif

define OPENSBI_C910_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(OPENSBI_C910_MAKE_ENV) \
	FW_TEXT_START=0xc0000000 \
	FW_JUMP_ADDR=0xc0200000 \
	$(MAKE) -C $(@D)
	mv $(@D)/build/platform/$(OPENSBI_C910_PLAT)/firmware/fw_jump.elf $(@D)/fw_jump_3G.elf
	mv $(@D)/build/platform/$(OPENSBI_C910_PLAT)/firmware/fw_jump.bin $(@D)/fw_jump_3G.bin

	$(MAKE) -C $(@D) distclean
	$(MAKE) -C $(@D) clean

	$(TARGET_MAKE_ENV) $(OPENSBI_C910_MAKE_ENV) \
	FW_TEXT_START=0x00000000 \
	FW_JUMP_ADDR=0x00200000 \
	$(MAKE) -C $(@D)
	mv $(@D)/build/platform/$(OPENSBI_C910_PLAT)/firmware/fw_jump.elf $(@D)/fw_jump_0G.elf
	mv $(@D)/build/platform/$(OPENSBI_C910_PLAT)/firmware/fw_jump.bin $(@D)/fw_jump_0G.bin
endef

ifneq ($(OPENSBI_C910_PLAT),)
OPENSBI_C910_INSTALL_IMAGES = YES
define OPENSBI_C910_INSTALL_IMAGES_CMDS
	mv $(@D)/fw_jump*.elf $(BINARIES_DIR)/hw/
	mv $(@D)/fw_jump*.bin $(BINARIES_DIR)/hw/
endef
endif

# libsbi.a is not a library meant to be linked in user-space code, but
# with bare metal code, which is why we don't install it in
# $(STAGING_DIR)/usr/lib
define OPENSBI_C910_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/build/lib/libsbi.a $(STAGING_DIR)/usr/share/opensbi/libsbi.a
endef

$(eval $(generic-package))
