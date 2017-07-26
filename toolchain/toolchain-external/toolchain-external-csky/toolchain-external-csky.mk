################################################################################
#
# toolchain-external-csky
#
################################################################################

TOOLCHAIN_EXTERNAL_CSKY_SITE = https://github.com/c-sky/tools/raw/master

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CSKY_GLIBC),y)
ifeq ($(BR2_ck610),y)
TOOLCHAIN_EXTERNAL_CSKY_SOURCE = csky-linux-tools-x86_64-glibc-linux-4.9.25-20170522.tar.gz
else
TOOLCHAIN_EXTERNAL_CSKY_SOURCE = csky-abiv2-linux-tools-x86_64-glibc-linux-4.9.25-20170522.tar.gz
endif
else # BR2_TOOLCHAIN_EXTERNAL_CSKY_GLIBC
ifeq ($(BR2_ck610),y)
TOOLCHAIN_EXTERNAL_CSKY_SOURCE = csky-linux-tools-x86_64-uclibc-linux-4.9.25-20170715.tar.gz
else
TOOLCHAIN_EXTERNAL_CSKY_SOURCE = csky-abiv2-linux-tools-x86_64-uclibc-linux-4.9.25-20170716.tar.gz
endif
endif # BR2_TOOLCHAIN_EXTERNAL_CSKY_GLIBC

$(eval $(toolchain-external-package))
