##############################################################################
#
# greenlet-ci
#
################################################################################

define GREENLET_CI_INSTALL_TARGET_CMDS
	cp -f ./package/greenlet-ci/greenlet-ci $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/greenlet-ci
endef

$(eval $(generic-package))
