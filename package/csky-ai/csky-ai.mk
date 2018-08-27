################################################################################
#
# csky ai
#
################################################################################

CSKY_AI_VERSION = 7d6458af147f82d3d3ed38261040ee9c06e0bf20
CSKY_AI_DEPENDENCIES = linux

ifneq ($(BR2_PACKAGE_CSKY_AI_VERSION), "")
CSKY_AI_VERSION = $(BR2_PACKAGE_CSKY_AI_VERSION)
endif

ifeq ($(BR2_CSKY_GERRIT_REPO),y)
CSKY_AI_SITE = ssh://${GITUSER}@192.168.0.78:29418/app/ai-module
CSKY_AI_SITE_METHOD = git
else
CSKY_AI_SITE = $(call github,c-sky,linux-sdk-ai,$(CSKY_AI_VERSION))
endif

CSKY_AI_INSTALL_TARGET = YES

#CSKY_AI_TARGET_DIR = $(TARGET_DIR)/ai
CSKY_NPU_SDK_DIR = $(@D)/target/bsp/dh7200_evb/npu_sdk/

define CSKY_AI_BUILD_CMDS
	@echo > $(CSKY_AI_DIR)/Makefile.param
	@echo "# Set buildroot toolchain & parameters" >> $(CSKY_AI_DIR)/Makefile.param
	@echo "LINUX_DIR=$(LINUX_DIR)" >> $(CSKY_AI_DIR)/Makefile.param
	@echo "PACKAGE_DIR := $(CSKY_AI_DIR)" >> $(CSKY_AI_DIR)/Makefile.param
	@echo "TOOLCHAIN_DIR := $(HOST_DIR)/bin" >> $(CSKY_AI_DIR)/Makefile.param
	@echo "TOOLCHAIN_PREFIX := $(TOOLCHAIN_EXTERNAL_PREFIX)" >> $(CSKY_AI_DIR)/Makefile.param
	@echo "CC := $(TARGET_CC)" >> $(CSKY_AI_DIR)/Makefile.param
	@echo "CXX := $(TARGET_CXX)" >> $(CSKY_AI_DIR)/Makefile.param
	@echo "AR := $(TARGET_AR)" >> $(CSKY_AI_DIR)/Makefile.param

	$(MAKE) BR2_PACKAGE_CSKY_AI_DEMO_VOD=$(BR2_PACKAGE_CSKY_AI_DEMO_VOD) \
		CC="$(TARGET_CC)" -C $(CSKY_NPU_SDK_DIR) -f buildroot.mk
endef

define CSKY_AI_INSTALL_TARGET_CMDS
	@echo ">>> Copy NPU driver/lib into target rootfs ..."
	@mkdir -p $(TARGET_DIR)/ko
	@cp -v $(CSKY_NPU_SDK_DIR)/install/ko/*.ko $(TARGET_DIR)/ko/
	@cp -v $(CSKY_NPU_SDK_DIR)/install/lib/*.so $(TARGET_DIR)/lib/
	@echo ">>> NPU driver/lib Install OK"
endef

$(eval $(generic-package))
