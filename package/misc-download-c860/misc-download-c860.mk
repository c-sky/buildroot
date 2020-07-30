################################################################################
#
# misc-download-c860
#
################################################################################

MISC_DOWNLOAD_C860_VERSION = 29f035d4e5706d736353bda6fc9dcf3e1883005e
MISC_DOWNLOAD_C860_SOURCE = misc-download-c860-$(MISC_DOWNLOAD_C860_VERSION).tar.gz
MISC_DOWNLOAD_C860_SITE = $(call github,c-sky,860_misc_downloads,$(MISC_DOWNLOAD_C860_VERSION))

MISC_DOWNLOAD_C860_INSTALL_IMAGES = YES

define MISC_DOWNLOAD_C860_CONFIGURE_CMDS
endef

define MISC_DOWNLOAD_C860_BUILD_CMDS
endef

define MISC_DOWNLOAD_C860_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/hw/
	cp $(@D)/* $(BINARIES_DIR)/hw/
endef

$(eval $(generic-package))
