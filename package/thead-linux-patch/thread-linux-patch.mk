###############################################################################
#
# thead linux patch
#
################################################################################

define THEAD_LINUX_PATCH_PREPARE_SRC_A
	if [ ! -f $(LINUX_DIR)/.stamp_extracted ]; then \
	cd $(LINUX_DIR)/../; \
	rm -rf a; \
	cp -raf linux-$(LINUX_VERSION) a; \
	cd -; \
	fi
endef
LINUX_POST_EXTRACT_HOOKS += THEAD_LINUX_PATCH_PREPARE_SRC_A

define THEAD_LINUX_PATCH_GENERATE_PATCH
	if [ ! -f $(LINUX_DIR)/.stamp_configured ]; then \
	cd $(LINUX_DIR)/../; \
	rm -rf b; \
	cp -raf linux-$(LINUX_VERSION) b; \
	rm $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch.xz; \
	diff -ruN a b > $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch; \
	xz -z $(BINARIES_DIR)/linux-$(LINUX_VERSION).patch; \
	cd -; \
	touch $(LINUX_DIR)/.stamp_patched_csky; \
	fi
endef
LINUX_POST_CONFIGURE_HOOKS += THEAD_LINUX_PATCH_GENERATE_PATCH
