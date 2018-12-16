##############################################################################
#
# whetstone-ci
#
################################################################################

define WHETSTONE_CI_INSTALL_TARGET_CMDS
	cp -f ./package/whetstone-ci/whetstone_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/whetstone_run
	cp -f ./package/whetstone-ci/whetstone_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/whetstone_parse
endef

$(eval $(generic-package))
