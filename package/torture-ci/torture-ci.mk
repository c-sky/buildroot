##############################################################################
#
# torture-ci
#
################################################################################



define TORTURE_CI_INSTALL_TARGET_CMDS
	cp -f ./package/torture-ci/torture_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/torture_run
endef

$(eval $(generic-package))
