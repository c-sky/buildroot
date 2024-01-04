################################################################################
#
# ocaml-dune
#
################################################################################

OCAML_DUNE_VERSION = 2.9.0
OCAML_DUNE_SITE = $(call github,ocaml,dune,$(OCAML_DUNE_VERSION))
OCAML_DUNE_LICENSE = MIT
OCAML_DUNE_LICENSE_FILES = LICENSE.md

HOST_OCAML_DUNE_DEPENDENCIES = host-ocaml

define HOST_OCAML_DUNE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) release PREFIX=$(HOST_DIR)
endef

define HOST_OCAML_DUNE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install PREFIX=$(HOST_DIR)
endef

$(eval $(host-generic-package))