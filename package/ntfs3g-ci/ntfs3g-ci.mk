##############################################################################
#
# ntfs3g-ci
#
################################################################################

define NTFS3G_CI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/csky-ci/
	cp -f package/ntfs3g-ci/ntfs3g_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/ntfs3g_run
	cp -f package/ntfs3g-ci/ntfs3g_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/ntfs3g_parse
endef

$(eval $(generic-package))
