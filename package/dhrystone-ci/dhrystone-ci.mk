##############################################################################
#
# dhrystone-ci
#
################################################################################

define DHRYSTONE_CI_INSTALL_TARGET_CMDS
	cp -f ./package/dhrystone-ci/dhrystone-ci $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/dhrystone-ci
endef

$(eval $(generic-package))
