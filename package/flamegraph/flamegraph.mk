##############################################################################
#
# flame graph
#
##############################################################################

FLAMEGRAPH_VERSION = f857ebc94bfe2a9bfdc4f1536ebacfb7466f69ba
FLAMEGRAPH_SITE = $(call github,brendangregg,FlameGraph,$(FLAMEGRAPH_VERSION))

define FLAMEGRAPH_CONFIGURE_CMDS
endef

define FLAMEGRAPH_BUILD_CMDS
endef


define FLAMEGRAPH_INSTALL_TARGET_CMDS
ln -s $(@D)/ $(HOST_DIR)/flamegraph
endef

$(eval $(generic-package))
