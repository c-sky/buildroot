################################################################################
#
# go-ci
#
################################################################################

HOST_GOBOOTSTRAP_TAR_ROOT = $(TARGET_DIR)/ci/go

ifeq ($(BR2_PACKAGE_GO_CI_EXTERNAL),y)
GO_CI_VERSION = 1.16.5

PRE_GO_INSTALL = $(HOST_DIR)/usr/local
HOST_PRE_GO_ROOT = $(PRE_GO_INSTALL)

GO_CI_SITE = https://storage.googleapis.com/golang
GO_CI_SOURCE = go$(GO_CI_VERSION).src.tar.gz
GO_CI_EXTRA_SOURCE = go$(GO_CI_VERSION).linux-amd64.tar.gz
GO_CI_EXTRA_DOWNLOADS = $(GO_CI_SITE)/$(GO_CI_EXTRA_SOURCE)
GO_CI_LICENSE = BSD-3-Clause
GO_CI_LICENSE_FILES = LICENSE

define GO_CI_PER_GO_EXTRACT
	mkdir -p $(PRE_GO_INSTALL)
	mkdir -p $(HOST_PRE_GO_ROOT)
	$(TAR) xf $(TOPDIR)/../dl/go-ci/$(GO_CI_EXTRA_SOURCE) -C $(HOST_PRE_GO_ROOT)
endef
GO_CI_POST_EXTRACT_HOOKS += GO_CI_PER_GO_EXTRACT

GO_CI_MAKE_ENV = \
	GOOS=linux \
	GOROOT_BOOTSTRAP="$(HOST_PRE_GO_ROOT)/go" \
	GOARCH=riscv64  \
	CGO_ENABLED=0

define GO_CI_BUILD_CMDS
	cd $(@D)/src && $(GO_CI_MAKE_ENV) ./bootstrap.bash
endef

define GO_CI_INSTALL_TARGET_CMDS
	mkdir -p $(HOST_GOBOOTSTRAP_TAR_ROOT)
	cp -f ./package/go-ci/go_run $(TARGET_DIR)/etc/init.ci/
	chmod a+x $(TARGET_DIR)/etc/init.ci/go_run
	cp -a $(@D)/../go-linux-riscv64-bootstrap.tbz $(HOST_GOBOOTSTRAP_TAR_ROOT)/
	cp $(TOPDIR)/../dl/go-ci/go$(GO_CI_VERSION).src.tar.gz  $(HOST_GOBOOTSTRAP_TAR_ROOT)/
	cd $(HOST_GOBOOTSTRAP_TAR_ROOT)/ ; bunzip2 go-linux-riscv64-bootstrap.tbz
	rm $(@D)/../go-linux-riscv64-bootstrap.tbz
	rm $(@D)/../go-linux-riscv64-bootstrap -rf
endef
else

GO_CI_VERSION = V1.0.0-rc3

GO_CI_SITE = ftp://eu95t-iotsoftwareftp01.eng.t-head.cn/Test/Test/Toolschain/go-riscv64/$(GO_CI_VERSION)
GO_CI_SOURCE = go1.19.8-T-HEAD-$(GO_CI_VERSION)-linux-riscv64.tar.gz
GO_CI_EXTRA_SOURCE = go1.19.8-T-HEAD-$(GO_CI_VERSION)-src-cmd.tar.gz
GO_CI_EXTRA_DOWNLOADS = $(GO_CI_SITE)/$(GO_CI_EXTRA_SOURCE)

define GO_CI_PER_GO_EXTRACT
	$(TAR) xf $(TOPDIR)/../dl/go-ci/$(GO_CI_EXTRA_SOURCE) -C $(@D)/src
	mv $(@D)/src/go1.19.8-T-HEAD-$(GO_CI_VERSION)-src-cmd $(@D)/src/cmd
endef
GO_CI_POST_EXTRACT_HOOKS += GO_CI_PER_GO_EXTRACT

define GO_CI_BUILD_CMDS
endef
define GO_CI_INSTALL_TARGET_CMDS
	mkdir -p $(HOST_GOBOOTSTRAP_TAR_ROOT)/GO-T-HEAD
	cp -f ./package/go-ci/go_run_thead $(TARGET_DIR)/etc/init.ci/go_run
	chmod a+x $(TARGET_DIR)/etc/init.ci/go_run
	rm -rf $(HOST_GOBOOTSTRAP_TAR_ROOT)/GO-T-HEAD/*
	cp -ar $(@D)/* $(HOST_GOBOOTSTRAP_TAR_ROOT)/GO-T-HEAD
endef
endif

$(eval $(generic-package))
