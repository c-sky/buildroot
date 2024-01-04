################################################################################
#
# ocaml
#
################################################################################

OCAML_VERSION = 4.13.0
OCAML_SITE = $(call github,ocaml,ocaml,$(OCAML_VERSION))
OCAML_LICENSE = LGPL-2.1
OCAML_LICENSE_FILES = LICENSE

HOST_OCAML_DEPENDENCIES = toolchain

define HOST_OCAML_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure --prefix=$(HOST_DIR))
endef

define HOST_OCAML_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_OCAML_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)  install
endef

$(eval $(host-generic-package))