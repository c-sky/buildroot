################################################################################
#
# csky examples
#
################################################################################

CSKY_EXAMPLES_VERSION = $(BR2_LINUX_KERNEL_EXT_CSKY_EXAMPLES_VERSION)
ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_EXAMPLES_GITHUB),y)
CSKY_EXAMPLES_SITE = $(call github,c-sky,linux-sdk-examples,$(CSKY_EXAMPLES_VERSION))
else
CSKY_EXAMPLES_SITE = $(BR2_LINUX_KERNEL_EXT_CSKY_EXAMPLES_GIT_URL)
CSKY_EXAMPLES_SITE_METHOD = git
endif

CSKY_EXAMPLES_INSTALL_TARGET = YES

define CSKY_EXAMPLES_BUILD_CMDS
	$(MAKE) BR2_PACKAGE_LIBSNDFILE=$(BR2_PACKAGE_LIBSNDFILE) \
		BR2_PACKAGE_FFMPEG=$(BR2_PACKAGE_FFMPEG) \
		CC="$(TARGET_CC)" -C $(@D)
endef

define CSKY_EXAMPLES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/example
	cp -dpfr $(@D)/*/bin/* $(TARGET_DIR)/example
	rm -f $(TARGET_DIR)/example/.gitkeep
endef

$(eval $(generic-package))
