################################################################################
#
# csky addons
#
################################################################################

CSKY_ADDONS_VERSION = 5c6e7476aac7701c15458c01066b04fecbcf0d2f

ifneq ($(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_VERSION), "")
CSKY_ADDONS_VERSION = $(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_VERSION)
endif

ifeq ($(BR2_CSKY_GERRIT_REPO),y)
ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_USE_VENDOR_REPO),y)
CSKY_ADDONS_SITE = ssh://${GITUSER}@192.168.0.78:29418/os/linux-csky-addons-vendors
else
CSKY_ADDONS_SITE = ssh://${GITUSER}@192.168.0.78:29418/os/linux-csky-addons
endif
CSKY_ADDONS_SITE_METHOD = git
else
ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_ADDONS_USE_VENDOR_REPO),y)
CSKY_ADDONS_SITE = $(call github,c-sky,addons-linux,$(CSKY_ADDONS_VERSION))
else
CSKY_ADDONS_SITE = $(call github,c-sky,linux-csky-addons,$(CSKY_ADDONS_VERSION))
endif
endif

ifeq ($(BR2_GERRIT),y)
BR2_CSKY_GERRIT_REPO=y
endif

$(eval $(generic-package))
