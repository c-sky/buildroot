################################################################################
#
# ocaml-menhir
#
################################################################################

OCAML_MENHIR_VERSION = 20211230
OCAML_MENHIR_SOURCE = menhir-$(OCAML_MENHIR_VERSION).tar.gz
OCAML_MENHIR_SITE = https://gitlab.inria.fr/fpottier/menhir/-/archive/$(OCAML_MENHIR_VERSION)
OCAML_MENHIR_LICENSE = LGPL-2.1
OCAML_MENHIR_LICENSE_FILES = LICENSE
BR_NO_CHECK_HASH_FOR += $(OCAML_MENHIR_SOURCE)

HOST_OCAML_MENHIR_DEPENDENCIES = host-ocaml host-ocaml-dune

DUNE = $(HOST_DIR)/bin/dune

define HOST_OCAML_MENHIR_BUILD_CMDS
	(cd $(@D); $(HOST_MAKE_ENV) $(DUNE) build @install)
endef

define HOST_OCAML_MENHIR_INSTALL_CMDS
	(cd $(@D); $(HOST_MAKE_ENV) $(DUNE) install  --prefix=$(HOST_DIR))
endef

$(eval $(host-generic-package))