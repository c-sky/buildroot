##############################################################################
#
# lmbench-ci
#
################################################################################

define LMBENCH_CI_INSTALL_TARGET_CMDS
	cp -f ./package/lmbench-ci/lmbench_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/lmbench_run
	cp -f ./package/lmbench-ci/CONFIG.lmbench $(TARGET_DIR)/usr/lib/csky-ci/
	sed -i 's/OUTPUT=/OUTPUT=\/dev\/'$(BR2_TARGET_GENERIC_GETTY_PORT)'/g' $(TARGET_DIR)/usr/lib/csky-ci/CONFIG.lmbench
	cp -f ./package/lmbench-ci/lmbench_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/lmbench_parse
endef

$(eval $(generic-package))
