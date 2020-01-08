##############################################################################
#
# zero-stage-boot
#
##############################################################################

ZERO_STAGE_BOOT_VERSION = 47807b5b959e0c7bd19d17a77ebe03748bfe42a9
ZERO_STAGE_BOOT_SOURCE = zero_stage_boot-$(ZERO_STAGE_BOOT_VERSION).tar.gz
ZERO_STAGE_BOOT_SITE = $(call github,c-sky,zero_stage_boot,$(ZERO_STAGE_BOOT_VERSION))

define ZERO_STAGE_BOOT_BUILD_CMDS
	$(TARGET_MAKE_ENV) CROSS_COMPILE=$(TARGET_CROSS) $(MAKE) -C $(@D)
endef

$(eval $(generic-package))
