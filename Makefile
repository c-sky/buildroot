BR2_VERSION		= 9d1d4818c39d97ad7a1cdf6e075b9acae6dfff71


BRW_ROOT	= $(PWD)
BRW_SITE	= https://github.com/buildroot/buildroot/archive/$(BR2_VERSION).tar.gz
BRW_FILE	= $(BR2_DL_DIR)/buildroot-$(BR2_VERSION).tar.gz
BRW_DIR		= $(BRW_ROOT)/buildroot-$(BR2_VERSION)
BRW_PATCH_DIR	= $(BRW_ROOT)/patches
ifneq ($(INSIDE_SITE),)
BRW_SITE	= $(INSIDE_SITE)/buildroot-$(BR2_VERSION).tar.gz
endif

DEFCONFIG = $(CONF)
O ?= $(CONF)
BR2_DL_DIR ?= $(BRW_ROOT)/dl

define DOWNLOAD
	mkdir -p $(BR2_DL_DIR); \
	if [ ! -f $(BRW_FILE) ]; then \
		wget -c $(BRW_SITE) -O $(BRW_FILE); \
	fi
endef

define COPYFILES
	set -e; \
	if [ ! -d $(BRW_DIR) ]; then \
		tar xf $(BRW_FILE) -C $(BRW_ROOT); \
		cp $(BRW_ROOT)/package/* $(BRW_DIR)/package/ -raf; \
		cp $(BRW_ROOT)/board/* $(BRW_DIR)/board/ -raf; \
		cp $(BRW_ROOT)/fs/* $(BRW_DIR)/fs/ -raf; \
		rm -rf package/ncurses/*.patch; \
		if [ -f ~/.gitconfig ]; then \
			cd $(BRW_DIR); \
			git init .; git add . > /dev/null; \
			git commit -m "$(BR2_VERSION)" > /dev/null; \
			git am $(BRW_PATCH_DIR)/*.patch; \
		else \
			$(BRW_DIR)/support/scripts/apply-patches.sh $(BRW_DIR) $(BRW_PATCH_DIR); \
		fi; \
	fi; \
	
	echo "DL_DIR=$(BR2_DL_DIR)" >> $(BRW_DIR)/Makefile; \
	if [ "$(INSIDE_SITE)" != "" ];then \
		sed -i '/^BR2_PRIMARY_SITE.*/d' $(BRW_ROOT)/configs_enhanced/* ;\
		echo "BR2_PRIMARY_SITE=\"$(INSIDE_SITE)/\"" | tee -a $(BRW_ROOT)/configs_enhanced/* ; \
	fi; \

	if [ -f $(BRW_ROOT)/configs/$(CONF) ];then \
		cp $(BRW_ROOT)/configs/$(CONF)  $(BRW_DIR)/configs/ -f; \
		echo "the file name is $(BRW_DIR)/configs/$(CONF)"; \
		cat $(BRW_ROOT)/configs/base_defconfig.fragment >> $(BRW_DIR)/configs/$(CONF); \
	elif [ -f $(BRW_ROOT)/configs_enhanced/$(CONF) ];then \
		cp $(BRW_ROOT)/configs_enhanced/$(CONF)  $(BRW_DIR)/configs/ -f; \
		echo "the file name is $(BRW_DIR)/configs_enhanced/$(CONF)"; \
		cat $(BRW_ROOT)/configs_enhanced/base_enhanced_defconfig.fragment >> $(BRW_DIR)/configs/$(CONF); \
	else  \
		echo "This config is from origin buildroot: $(CONF)"; \
	fi; \

endef

.PHONY: all
all .DEFAULT:
	@$(call DOWNLOAD)
	@$(call COPYFILES)
	make -C $(BRW_DIR) $(DEFCONFIG) CONF= O=$(BRW_ROOT)/$(O)
	make -C  $(BRW_ROOT)/$(O) CONF=  $@
