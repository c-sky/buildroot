##############################################################################
#
# CSKY Debug Server Console
#
##############################################################################

CSKY_JTAG_VERSION = CSKY-DebugServer-linux-x86_64-V5.10.4-20200429
CSKY_JTAG_FILE = $(CSKY_JTAG_VERSION).sh
CSKY_JTAG_SOURCE = $(CSKY_JTAG_FILE).tar.gz
CSKY_JTAG_SITE = http://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource/1355977/1590483269667
CSKY_JTAG_LINENUM = 277

define CSKY_JTAG_EXTRACT_CMDS
	tar -zxf $(CSKY_JTAG_DL_DIR)/$(CSKY_JTAG_SOURCE) -C $(@D)
endef

define CSKY_JTAG_INSTALL_TARGET_CMDS
	tail -n +$(CSKY_JTAG_LINENUM) $(@D)/$(CSKY_JTAG_FILE) > $(@D)/tmp.tar.gz
	mkdir -p $(HOST_DIR)/csky-jtag
	tar -zxf $(@D)/tmp.tar.gz -C $(HOST_DIR)/csky-jtag
endef

$(eval $(generic-package))
