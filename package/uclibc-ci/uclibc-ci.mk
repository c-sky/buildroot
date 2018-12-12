##############################################################################
#
# uclibc-ci
#
################################################################################

define UCLIBC_CI_INSTALL_TARGET_CMDS
	cp -f ./package/uclibc-ci/uclibc-ci $(TARGET_DIR)/etc/init.ci/
	cp -f ./package/uclibc-ci/uclibc-ng-test.skiplist $(TARGET_DIR)/usr/lib/csky-ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/uclibc-ci
endef

$(eval $(generic-package))
