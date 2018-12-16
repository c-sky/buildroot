##############################################################################
#
# ltp-ci
#
################################################################################

skplst=ltp-skiplist

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
	skplst=ltp-uclibc-skiplist
else ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),y)
	skplst=ltp-glibc-skiplist
endif

define LTP_CI_INSTALL_TARGET_CMDS
	cp -f ./package/ltp-ci/ltp_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/ltp_run
	cp -f ./package/ltp-ci/$(skplst) $(TARGET_DIR)/usr/lib/csky-ci/ltp-skiplist
	cp -f ./package/ltp-ci/ltp_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/ltp_parse
endef

$(eval $(generic-package))
