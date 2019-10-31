################################################################################
#
# misc-download-c860
#
################################################################################

MISC_DOWNLOAD_C860_VERSION = 63f88a0aec0f9db43e1efda8c419ddf9e6a11072
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
