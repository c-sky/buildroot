##############################################################################
#
# lmbench-ci
#
################################################################################

define LMBENCH_CI_INSTALL_TARGET_CMDS
	cp -f ./package/lmbench-ci/lmbench-ci $(TARGET_DIR)/etc/init.ci/
	cp -f ./package/lmbench-ci/CONFIG.lmbench $(TARGET_DIR)/usr/lib/csky-ci/
	sed -i 's/OUTPUT=/OUTPUT=\/dev\/'$(BR2_TARGET_GENERIC_GETTY_PORT)'/g' $(TARGET_DIR)/usr/lib/csky-ci/CONFIG.lmbench
	chmod a+x $(TARGET_DIR)/etc/init.ci/lmbench-ci
	cp -f ./package/lmbench-ci/lmbench_parse.sh $(HOST_DIR)/csky-ci/parse_script
endef

$(eval $(generic-package))
