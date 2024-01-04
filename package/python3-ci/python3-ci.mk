##############################################################################
#
#  python3-ci
#
################################################################################

#OPENJDK_SPECJVM_VERSION = 2008_1_01
#OPENJDK_SPECJVM_SITE = http://spec.cs.miami.edu/downloads/osg/java
#OPENJDK_SPECJVM_SOURCE = SPECjvm$(OPENJDK_SPECJVM_VERSION)_setup.jar
#OPENJDK_CI_EXTRA_DOWNLOADS=$(OPENJDK_SPECJVM_SITE)/$(OPENJDK_SPECJVM_SOURCE)

PYTHON3_CI_ROOT = $(TARGET_DIR)/ci/PYTHON3

define PYTHON3_CI_INSTALL_TARGET_CMDS
	mkdir -p $(PYTHON3_CI_ROOT)
	cp -rf $(TARGET_DIR)/../build/python3-${PYTHON3_VERSION} $(PYTHON3_CI_ROOT)
	
endef

$(eval $(generic-package))
