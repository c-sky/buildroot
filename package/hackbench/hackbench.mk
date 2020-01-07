##############################################################################
#
# hackbench
#
##############################################################################

define HACKBENCH_COMPILE_CASE
endef

define HACKBENCH_INSTALL_TARGET_CMDS
	$(TARGET_CC) -Wall -O2 -o $(TARGET_DIR)/bin/hackbench package/hackbench/hackbench.c -lpthread
	chmod a+x $(TARGET_DIR)/bin/hackbench
endef

$(eval $(generic-package))
