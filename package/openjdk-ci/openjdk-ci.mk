##############################################################################
#
#  openjdk-ci
#
################################################################################

OPENJDK_SPECJVM_VERSION = 2008_1_01
#OPENJDK_SPECJVM_SITE = http://spec.cs.miami.edu/downloads/osg/java
OPENJDK_SPECJVM_SITE = ftp://10.63.58.39/CPU-SIT/openjdk-ci
OPENJDK_SPECJVM_SOURCE = SPECjvm$(OPENJDK_SPECJVM_VERSION)_setup.jar
OPENJDK_CI_EXTRA_DOWNLOADS=$(OPENJDK_SPECJVM_SITE)/$(OPENJDK_SPECJVM_SOURCE)

OPENJDK_CI_ROOT = $(TARGET_DIR)/ci/openjdk

define OPENJDK_CI_INSTALL_TARGET_CMDS
	mkdir -p $(OPENJDK_CI_ROOT)
	cp -a $(PWD)/../dl/openjdk-ci/SPECjvm2008_1_01_setup.jar $(OPENJDK_CI_ROOT)/

	cp -f ./package/openjdk-ci/openjdk_run $(TARGET_DIR)/etc/init.ci/
	cp -f ./package/openjdk-ci/openjdk_run_test $(TARGET_DIR)/etc/init.ci/
	cp -f ./package/openjdk-ci/jdk.sh $(TARGET_DIR)/etc/profile.d/
	chmod a+x $(TARGET_DIR)/etc/init.ci/openjdk_run
endef

$(eval $(generic-package))
