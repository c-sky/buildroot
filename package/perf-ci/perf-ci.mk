##############################################################################
#
# perf-ci
#
################################################################################

define PERF_CI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/perf-test
	output/host/bin/csky-buildroot-*-gcc -O0 -g -fexceptions -mbacktrace package/perf-ci/callchain_test.c -o callchain_test
	cp -f callchain_test $(TARGET_DIR)/usr/lib/perf-test
	cp -f ./package/perf-ci/perf_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/perf_run
	cp -f ./package/perf-ci/perf_parse $(HOST_DIR)/csky-ci/parse_script/
	chmod a+x $(HOST_DIR)/csky-ci/parse_script/perf_parse
endef

$(eval $(generic-package))
