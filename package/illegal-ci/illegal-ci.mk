##############################################################################
#
#  python3-ci
#
################################################################################

#OPENJDK_SPECJVM_VERSION = 2008_1_01
#OPENJDK_SPECJVM_SITE = http://spec.cs.miami.edu/downloads/osg/java
#OPENJDK_SPECJVM_SOURCE = SPECjvm$(OPENJDK_SPECJVM_VERSION)_setup.jar
#OPENJDK_CI_EXTRA_DOWNLOADS=$(OPENJDK_SPECJVM_SITE)/$(OPENJDK_SPECJVM_SOURCE)

ILLEGAL_CI_ROOT = $(TARGET_DIR)/../build/illegal_inst_test

define ILLEGAL_CI_INSTALL_TARGET_CMDS
	mkdir -p $(ILLEGAL_CI_ROOT)
	cp package/illegal-ci/illegal-inst-test.py $(ILLEGAL_CI_ROOT)
	cd $(ILLEGAL_CI_ROOT); python3 illegal-inst-test.py  -l 20000 -c ftp://eu95t-iotsoftwareftp01.eng.t-head.cn/Test/Test/Toolschain/gnu-riscv/V2.6.1/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1.tar.gz  \
	-q ftp://eu95t-iotsoftwareftp01.eng.t-head.cn/Test/Test/qemu/V4.0.0/xuantie-qemu-x86_64-Ubuntu-18.04.tar.gz  -t c908v
	
endef

$(eval $(generic-package))
