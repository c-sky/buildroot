##############################################################################
#
# glibc ci
#
################################################################################

<<<<<<< 2727efc6e78b7dee6079f4d85a7a54cd0b2eb38e
<<<<<<< 84f68d58a151953c7281f01370f66538cea62e28
CSKY_GLIBC_CI_VERSION = 3aab904d77f0c7e0d40a9fa565b372e0daab42d7
=======
CSKY_GLIBC_CI_VERSION = 9601e4bc9f6e35c1ca9420366618384038a205eb
>>>>>>> csky-glibc-ci: update sleep time & ip
=======
CSKY_GLIBC_CI_VERSION = 80594c8b3e2e44c824274e34637647a7a69cffff
>>>>>>> csky-glibc-ci: Fix ip
CSKY_GLIBC_CI_SITE = $(call github,c-sky,csky-glibc-ci,$(CSKY_GLIBC_CI_VERSION))

CSKY_GLIBC_CI_DEPENDENCIES = openssh

define CSKY_GLIBC_CI_INSTALL_TARGET_CMDS
mkdir -p $(HOST_DIR)/csky-glibc-ci/
mkdir -p $(TARGET_DIR)/root/.ssh
cp -f $(@D)/csky-glibc-ci.sh $(HOST_DIR)/csky-glibc-ci/
cp -f $(@D)/make-check.sh $(HOST_DIR)/csky-glibc-ci/
cp -f ~/.ssh/id_rsa.pub  $(TARGET_DIR)/root/.ssh/authorized_keys
cp -f $(@D)/S50sshd $(TARGET_DIR)/etc/init.d/
rm output/build/glibc-*/build -rf
cd $(BUILD_DIR)/glibc-*/;tar -cJf $(BINARIES_DIR)/glibc.tar.xz ./;cd -
endef

$(eval $(generic-package))
