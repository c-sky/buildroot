################################################################################
#
# csky addons
#
################################################################################

CSKY_ADDONS_VERSION = c293aaf9ee74baa2d1c8247255a515c449af70c1

ifneq ($(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_VERSION), "")
CSKY_ADDONS_VERSION = $(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_VERSION)
endif

ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_GITHUB),y)
CSKY_ADDONS_SITE = $(call github,c-sky,addons-linux,$(CSKY_ADDONS_VERSION))
else
CSKY_ADDONS_SITE = $(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_GIT_URL)
CSKY_ADDONS_SITE_METHOD = git
endif

$(eval $(generic-package))
