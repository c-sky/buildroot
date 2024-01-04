################################################################################
#
# klitmus test
#
################################################################################

KLITMUS_TEST_DEPENDENCIES = host-herdtools7 linux

KLITMUS_DIR = $(LINUX_DIR)/tools/memory-model/litmus-tests
KLITMUS_FILES = $(notdir $(wildcard $(KLITMUS_DIR)/*.litmus))
KLITMUS_NAMES = $(KLITMUS_FILES:%.litmus=%)

define KLITMUS_TEST_BUILD_CMDS
	mkdir -p $(@D)/klitmus
	$(foreach f, $(KLITMUS_NAMES), \
		@echo $(f)
		mkdir -p $(@D)/klitmus/$(f)
		$(HOST_DIR)/usr/bin/klitmus7 -o $(@D)/klitmus/$(f) $(KLITMUS_DIR)/$(f).litmus
		sed -i 's:/lib/modules/$$(shell uname -r)/build:$(LINUX_DIR):g' $(@D)/klitmus/$(f)/Makefile
		sed -i '2,3d' $(@D)/klitmus/$(f)/Makefile
		sed -i '3,6d' $(@D)/klitmus/$(f)/Makefile
		(cd $(@D)/klitmus/$(f); $(LINUX_MAKE_ENV) $(MAKE) ARCH=$(KERNEL_ARCH) CROSS_COMPILE="$(TARGET_CROSS)"; cd $(@D))
	)
endef

define KLITMUS_TEST_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/klitmus
	$(foreach f, $(KLITMUS_NAMES), \
		mkdir -p $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/klitmus/$(f)
		$(INSTALL) -m 0755 $(@D)/klitmus/$(f)/litmus000.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/klitmus/$(f)/litmus000.ko
	)

	cp -f ./package/klitmus-test/klitmus_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/klitmus_run
endef

$(eval $(generic-package))
