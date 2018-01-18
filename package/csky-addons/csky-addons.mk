################################################################################
#
# csky addons
#
################################################################################

CSKY_ADDONS_VERSION = 972d0d7bb62f56e967e2afdca1cabee38b3ec986

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
