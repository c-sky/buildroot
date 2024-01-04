##############################################################################
#
# pts-ci
#
################################################################################

define PTS_CI_INSTALL_TARGET_CMDS
	cp -f ./package/pts-ci/pts_run $(TARGET_DIR)/etc/init.ci/
	cp -f ./package/pts-ci/ptssmp_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/pts_run
	chmod a+x $(TARGET_DIR)/etc/init.ci/ptssmp_run
	cp -f ./package/pts-ci/pts_parse $(HOST_DIR)/csky-ci/parse_script/
	cp -f ./package/pts-ci/ptssmp_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/pts_parse
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/ptssmp_parse
	#TODO: use wget get lastest data
	cp -rf ./package/pts-ci/lastest $(HOST_DIR)/csky-ci/parse_script/
	cp -rf ./package/pts-ci/gnuplot $(HOST_DIR)/csky-ci/parse_script/
endef

$(eval $(generic-package))
