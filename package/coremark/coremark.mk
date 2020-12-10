################################################################################
#
# CoreMark
#
################################################################################

COREMARK_VERSION = 1.01
COREMARK_SITE = $(call github,eembc,coremark,v$(COREMARK_VERSION))
COREMARK_LICENSE = Apache-2.0
COREMARK_LICENSE_FILES = LICENSE.md

ifeq ($(BR2_PACKAGE_HAS_TOOLCHAIN_EXTERNAL)$(BR2_riscv),yy)
COREMARK_XCFLAGS="-O3 -static -funroll-all-loops -finline-limit=500 -fgcse-sm -fno-schedule-insns --param max-rtl-if-conversion-unpredictable-cost=100 -msignedness-cmpiv -fno-code-hoisting -mno-thread-jumps1 -mno-iv-adjust-addr-cost -mno-expand-split-imm"
else
COREMARK_XCFLAGS="-O2"
endif

define COREMARK_BUILD_CMDS
 $(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" XCFLAGS=$(COREMARK_XCFLAGS) -C $(@D) \
 PORT_DIR=linux$(if $(BR2_ARCH_IS_64),64) EXE= link
endef

define COREMARK_INSTALL_TARGET_CMDS
 $(INSTALL) -D $(@D)/coremark $(TARGET_DIR)/usr/bin/coremark
endef

$(eval $(generic-package))
