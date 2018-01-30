################################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION = 9165bdb08b5c5dcdd12dbfbf2534df582294c2b3

ifneq ($(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_VERSION), "")
CSKY_ARCH_VERSION = $(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_VERSION)
endif

ifeq ($(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_GITHUB),y)
CSKY_ARCH_SITE = $(call github,c-sky,csky-linux,$(CSKY_ARCH_VERSION))
else
CSKY_ARCH_SITE = $(BR2_LINUX_KERNEL_EXT_CSKY_ARCH_GIT_URL)
CSKY_ARCH_SITE_METHOD = git
endif

$(eval $(generic-package))
