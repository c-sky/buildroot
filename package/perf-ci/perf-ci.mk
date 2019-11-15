##############################################################################
#
# perf-ci
#
################################################################################

ifeq ($(BR2_csky),y)
define PERF_CI_COMPILE_CASE
	$(TARGET_CC) -O0 -g -fexceptions -mbacktrace package/perf-ci/callchain_test.c -o callchain_test
endef
else
define PERF_CI_COMPILE_CASE
	$(TARGET_CC) -O0 -g -fexceptions -fno-omit-frame-pointer package/perf-ci/callchain_test.c -o callchain_test
endef
endif

define PERF_CI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/perf-test
	$(PERF_CI_COMPILE_CASE)
	cp -f callchain_test $(TARGET_DIR)/usr/lib/perf-test
	cp -f ./package/perf-ci/perf-kmem.sh $(TARGET_DIR)/usr/lib/perf-test
	cp -f ./package/perf-ci/perf_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/perf_run
	cp -f ./package/perf-ci/perf_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/perf_parse
endef

$(eval $(generic-package))
