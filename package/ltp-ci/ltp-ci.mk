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
	cp -f ./package/ltp-ci/ltp-ci $(TARGET_DIR)/etc/init.ci/
	cp -f ./package/ltp-ci/$(skplst) $(TARGET_DIR)/usr/lib/csky-ci/ltp-skiplist
	chmod a+x $(TARGET_DIR)/etc/init.ci/ltp-ci
endef

$(eval $(generic-package))
