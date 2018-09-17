################################################################################
#
# csky ai
#
################################################################################

CSKY_AI_VERSION = $(BR2_PACKAGE_CSKY_AI_VERSION)
CSKY_AI_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_CSKY_AI_DEMO_VOD), y)
CSKY_AI_DEPENDENCIES += gstreamer1
CSKY_AI_DEPENDENCIES += gst1-rtsp-server
CSKY_AI_DEPENDENCIES += gst1-plugins-good
CSKY_AI_DEPENDENCIES += gst1-plugins-ugly
CSKY_AI_DEPENDENCIES += gst1-plugins-base
endif

ifeq ($(CSKY_AI_VERSION), "")
$(error BR2_PACKAGE_CSKY_AI_VERSION must be set)
endif

ifeq ($(BR2_CSKY_GERRIT_REPO),y)
CSKY_AI_SITE = ssh://${GITUSER}@192.168.0.78:29418/app/ai-module
CSKY_AI_SITE_METHOD = git
else
CSKY_AI_SITE = $(call github,c-sky,linux-sdk-ai,$(CSKY_AI_VERSION))
endif

CSKY_AI_INSTALL_TARGET = YES

# $(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE), for example: "board/csky/anole_ck810/linux.config"
# To get board name, replace "/" with " ",for example: "board csky anole_ck810 linux.config"
CSKY_BOARD_NAME:=$(subst /, ,$(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE))
# Then, get 3rd word, that is the board name
CSKY_BOARD_NAME:=$(word 3,$(CSKY_BOARD_NAME))

define CSKY_AI_BUILD_CMDS
	@echo > $(CSKY_AI_DIR)/target/buildroot.param
	@echo "# Set buildroot parameters" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "BUILDROOT_TOPDIR=$(TOPDIR)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "BUILDROOT_BASE_DIR=$(BASE_DIR)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "CSKY_BOARD_NAME=$(CSKY_BOARD_NAME)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "LINUX_DIR=$(LINUX_DIR)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "PACKAGE_DIR := $(CSKY_AI_DIR)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "INSTALL_DIR := $(CSKY_AI_DIR)/target/install_$(CSKY_BOARD_NAME)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "TOOLCHAIN_DIR := $(HOST_DIR)/bin" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "TOOLCHAIN_PREFIX := $(TOOLCHAIN_EXTERNAL_PREFIX)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "CC := $(TARGET_CC)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "CXX := $(TARGET_CXX)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "CPP := $(TARGET_CXX)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "AR := $(TARGET_AR)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "RAN := $(TARGET_RANLIB)" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "# Set build targets" >> $(CSKY_AI_DIR)/target/buildroot.param
	@echo "CSKY_AI_DEMO_VOD := $(BR2_PACKAGE_CSKY_AI_DEMO_VOD)" >> $(CSKY_AI_DIR)/target/buildroot.param


	@if [ $(CSKY_BOARD_NAME) = dh7200_evb_ai ]; then \
		mkdir -p $(CSKY_AI_DIR)/target/install_$(CSKY_BOARD_NAME)/lib; \
		cp -vf $(BASE_DIR)/host/opt/ext-toolchain/csky-abiv2-linux/lib/libstdc++.so.6 \
			$(CSKY_AI_DIR)/target/install_$(CSKY_BOARD_NAME)/lib/; \
	fi
	$(MAKE) -C $(CSKY_AI_DIR)/target/ -f buildroot.mk
endef

define CSKY_AI_INSTALL_TARGET_CMDS
	@cp -rv $(CSKY_AI_DIR)/target/install_$(CSKY_BOARD_NAME)/* $(TARGET_DIR)/
	@echo ">>> AI SDK Install OK"
endef

$(eval $(generic-package))
