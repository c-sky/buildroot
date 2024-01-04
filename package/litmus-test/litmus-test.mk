################################################################################
#
# litmus test
#
################################################################################

LITMUS_TEST_VERSION = $(call qstrip,$(BR2_PACKAGE_LITMUS_TEST_MODE))
LITMUS_TEST_SITE = $(call github,GeassCore,litmus-tests-riscv,$(LITMUS_TEST_VERSION))
LITMUS_TEST_LICENSE = BSD-2-Clause
LITMUS_TEST_LICENSE_FILES = LICENCE
LITMUS_TEST_DEPENDENCIES = host-herdtools7 linux

define LITMUS_TEST_BUILD_CMDS
	(cd $(@D) ;$(HOST_MAKE_ENV) $(MAKE) hw-tests CORES=$(BR2_PACKAGE_LITMUS_TEST_CORE) GCC="$(TARGET_CC)")
endef

define LITMUS_TEST_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin/litmus
	$(INSTALL) -m 0755 $(@D)/hw-tests/run.exe $(TARGET_DIR)/usr/bin/litmus/run.exe
	$(INSTALL) -m 0755 $(@D)/hw-tests/run.sh $(TARGET_DIR)/usr/bin/litmus/run.sh

	cp -f ./package/litmus-test/litmus_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/litmus_run
endef

$(eval $(generic-package))
