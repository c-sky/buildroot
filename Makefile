BR2_VERSION		= ded3f9954f158b5d9cd08ae76749eade72fcca3a

.PHONY: all
all: compile

BRW_ROOT	= $(PWD)
BRW_SITE	= https://github.com/buildroot/buildroot/archive/$(BR2_VERSION).tar.gz
BRW_FILE	= $(BR2_DL_DIR)/buildroot-$(BR2_VERSION).tar.gz
BRW_DIR		= $(BRW_ROOT)/buildroot-$(BR2_VERSION)
BRW_PATCH_DIR	= $(BRW_ROOT)/patches

O ?= $(CONF)
BR2_DL_DIR ?= $(BRW_ROOT)/dl

define DOWNLOAD
	mkdir -p $(BR2_DL_DIR); \
	if [ ! -f $(BRW_FILE) ]; then \
		wget $(BRW_SITE) -O $(BRW_FILE); \
	fi
endef

define COPYFILES
	if [ ! -d $(BRW_DIR) ]; then \
		tar xf $(BRW_FILE) -C $(BRW_ROOT); \
		cp $(BRW_ROOT)/package/* $(BRW_DIR)/package/ -raf; \
		cp $(BRW_ROOT)/boot/* $(BRW_DIR)/boot/ -raf; \
		cp $(BRW_ROOT)/board/* $(BRW_DIR)/board/ -raf; \
		rm -rf package/ncurses/*.patch; \
		echo "DL_DIR=$(BR2_DL_DIR)" >> $(BRW_DIR)/Makefile; \
		if [ -f ~/.gitconfig ]; then \
			cd $(BRW_DIR); \
			git init .; git add . > /dev/null; \
			git commit -m "$(BR2_VERSION)" > /dev/null; \
			git am $(BRW_PATCH_DIR)/*.patch; \
		else \
			$(BRW_DIR)/support/scripts/apply-patches.sh $(BRW_DIR) $(BRW_PATCH_DIR); \
		fi; \
	fi; \
	cp $(BRW_ROOT)/configs/$(CONF) $(BRW_DIR)/configs/$(CONF) -f;
endef

.PHONY: prepare
prepare:
	@$(call DOWNLOAD)
	@$(call COPYFILES)

.PHONY: configure
configure: prepare
	make -C $(BRW_DIR) $(CONF) O=$(BRW_ROOT)/$(O)

.PHONY: compile
compile: configure
	make -C $(BRW_ROOT)/$(O)
