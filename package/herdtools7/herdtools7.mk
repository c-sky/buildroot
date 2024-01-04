################################################################################
#
# herdtools7
#
################################################################################

HERDTOOLS7_VERSION = 7.56
HERDTOOLS7_SITE = $(call github,herd,herdtools7,$(HERDTOOLS7_VERSION))
HERDTOOLS7_LICENSE = MIT
HERDTOOLS7_LICENSE_FILES = LICENSE.txt

HOST_HERDTOOLS7_DEPENDENCIES = host-ocaml host-ocaml-dune host-ocaml-menhir

define HOST_HERDTOOLS7_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) all PREFIX=$(HOST_DIR)
endef

define HOST_HERDTOOLS7_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install PREFIX=$(HOST_DIR)
endef

$(eval $(host-generic-package))