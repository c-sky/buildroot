################################################################################
#
# jamvm
#
################################################################################

JAMVM_CSKY_VERSION = 2.0.0
JAMVM_CSKY_SITE = http://downloads.sourceforge.net/project/jamvm/jamvm/JamVM%20$(JAMVM_CSKY_VERSION)
JAMVM_CSKY_SOURCE = jamvm-$(JAMVM_CSKY_VERSION).tar.gz
JAMVM_CSKY_LICENSE = GPL-2.0+
JAMVM_CSKY_LICENSE_FILES = COPYING
JAMVM_CSKY_DEPENDENCIES = zlib classpath
# For 0001-Use-fenv.h-when-available-instead-of-fpu_control.h.patch
JAMVM_CSKY_AUTORECONF = YES
# int inlining seems to crash jamvm, don't build shared version of internal lib
JAMVM_CSKY_CONF_OPTS = \
	--with-classpath-install-dir=/usr \
	--disable-int-inlining \
	--disable-shared \
	--without-pic \
	--enable-ffi \

ifeq ($(BR2_PACKAGE_LIBFFI),y)
JAMVM_CSKY_DEPENDENCIES += libffi
endif

# Needed for autoreconf
define JAMVM_CSKY_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef

JAMVM_CSKY_POST_PATCH_HOOKS += JAMVM_CSKY_CREATE_M4_DIR

$(eval $(autotools-package))
