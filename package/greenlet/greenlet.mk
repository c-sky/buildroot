#
##############################################################################
#
# greenlet
#
################################################################################

GREENLET_VERSION = 2e2cab9e05321b187188498888bb0dfaa020c417
GREENLET_SITE = $(call github,c-sky,greenlet,$(GREENLET_VERSION))
GREENLET_DEPENDENCIES += python

define GREENLET_CONFIGURE_CMDS
echo CROSS_TOOLCHAIN_PREFIX=$(HOST_DIR)/bin/$(GNU_TARGET_NAME)- > $(@D)/config
echo PYTHON_INCLUDE= $(HOST_DIR)/csky-buildroot-linux-gnuabiv2/sysroot/usr/include/python*/ >> $(@D)/config
cp -f package/greenlet/greenlet.makefile $(@D)/Makefile
endef

define GREENLET_BUILD_CMDS
make -C $(@D)
endef

define GREENLET_INSTALL_TARGET_CMDS
cp -f $(@D)/out/greenlet.so $(TARGET_DIR)/usr/lib/python2.7/site-packages/
cp -f package/greenlet/greenlet_test.py $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
