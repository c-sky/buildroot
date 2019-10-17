################################################################################
#
# misc-download-c860
#
################################################################################

MISC_DOWNLOAD_C860_VERSION = be21468e10d5d2a4c4e17bbfc964c304d89cf575
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
