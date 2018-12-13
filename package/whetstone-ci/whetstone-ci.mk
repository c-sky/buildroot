##############################################################################
#
# whetstone-ci
#
################################################################################

define WHETSTONE_CI_INSTALL_TARGET_CMDS
	cp -f ./package/whetstone-ci/whetstone-ci $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/whetstone-ci
endef

$(eval $(generic-package))
