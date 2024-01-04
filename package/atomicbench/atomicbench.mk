ifeq ($(BR2_PACKAGE_ATOMICBENCH_SOURCE_MODE),y)
	ATOMICBENCH_VERSION = 6aec0e50e77513637781f9c0e15a04c7550c2149
	ATOMICBENCH_SITE = $(call github,GeassCore,atomicbench,$(ATOMICBENCH_VERSION))
else
	ATOMICBENCH_SOURCE = atomicbench.tar.gz
	ATOMICBENCH_SITE = ftp://10.63.58.39/CPU-SIT
endif

ATOMICBENCH_LICENSE = Apache-2.0
ATOMICBENCH_LICENSE_FILES = LICENSE.md

ifeq ($(BR2_PACKAGE_ATOMICBENCH_SOURCE_MODE),y)

define ATOMICBENCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) CROSS_COMPILE=$(notdir $(TARGET_CROSS:%-=%)) $(MAKE) -C $(@D)
endef

define ATOMICBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/build/benchmark/$(notdir $(TARGET_CROSS:%-=%))/main.bin $(TARGET_DIR)/usr/bin/atomicbench
endef

else
	define ATOMICBENCH_INSTALL_TARGET_CMDS
 	$(INSTALL) -D $(@D)/build/atomicbench $(TARGET_DIR)/usr/bin/atomicbench
endef
endif



$(eval $(generic-package))

