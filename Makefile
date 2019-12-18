BR2_VERSION		= ded3f9954f158b5d9cd08ae76749eade72fcca3a

.PHONY: all
all .DEFAULT: prepare
	make -C $(BRW_DIR) $(CONF) O=$(BRW_ROOT)/$(O)
	make -C $(BRW_ROOT)/$(O) $@

BRW_ROOT	= $(PWD)
BRW_PRIMARY_SITE	= ftp://192.168.0.117/QA/Test/buildroot2-dl/
BRW_PRI_SITE	= $(BRW_PRIMARY_SITE)/buildroot-$(BR2_VERSION).tar.gz
BRW_SITE	= https://github.com/buildroot/buildroot/archive/$(BR2_VERSION).tar.gz
BRW_FILE	= $(BR2_DL_DIR)/buildroot-$(BR2_VERSION).tar.gz
BRW_DIR		= $(BRW_ROOT)/buildroot-$(BR2_VERSION)
BRW_PATCH_DIR	= $(BRW_ROOT)/patches

O ?= $(CONF)
BR2_DL_DIR ?= $(BRW_ROOT)/dl

define DOWNLOAD
	mkdir -p $(BR2_DL_DIR); \
	if [ ! -f $(BRW_FILE) ]; then \
		wget -c -T 10 $(BRW_PRI_SITE) ; \
		if [ -f buildroot-$(BR2_VERSION).tar.gz ]; then \
			mv buildroot-$(BR2_VERSION).tar.gz $(BRW_FILE) ;\
		fi; \
		if [ ! -f $(BRW_FILE) ]; then \
			wget -c $(BRW_SITE) -O $(BRW_FILE); \
		fi; \
	fi
endef

define COPYFILES
	if [ ! -d $(BRW_DIR) ]; then \
		tar xf $(BRW_FILE) -C $(BRW_ROOT); \
		cp $(BRW_ROOT)/package/* $(BRW_DIR)/package/ -raf; \
		cp $(BRW_ROOT)/boot/* $(BRW_DIR)/boot/ -raf; \
		cp $(BRW_ROOT)/board/* $(BRW_DIR)/board/ -raf; \
		cp $(BRW_ROOT)/fs/* $(BRW_DIR)/fs/ -raf; \
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
	cp $(BRW_ROOT)/configs/* $(BRW_DIR)/configs/ -f; \
	cp $(BRW_ROOT)/configs_enhanced/* $(BRW_DIR)/configs/ -f; \
	sed -i '/^BR2_PRIMARY_SITE.*/d' $(BRW_DIR)/configs/* ;\
	echo "BR2_PRIMARY_SITE=\"ftp://192.168.0.117/QA/Test/buildroot2-dl/\"" | tee -a $(BRW_DIR)/configs/* ;
endef

.PHONY: prepare
prepare:
	@$(call DOWNLOAD)
	@$(call COPYFILES)
