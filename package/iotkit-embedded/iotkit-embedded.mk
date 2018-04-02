################################################################################
#
#iotkit embedded
#
################################################################################
IOTKIT_EMBEDDED_VERSION = RELEASED_V2.03
IOTKIT_EMBEDDED_SITE = $(call github,aliyun,iotkit-embedded,$(IOTKIT_EMBEDDED_VERSION))

define IOTKIT_EMBEDDED_EXTRACT_CMDS
	$(TAR) xzvf $(DL_DIR)/iotkit-embedded-$(IOTKIT_EMBEDDED_VERSION).tar.gz -C $(@D)
	mv $(@D)/iotkit-embedded-$(IOTKIT_EMBEDDED_VERSION)/* $(@D)
	$(RM) -r $(@D)/iotkit-embedded-$(IOTKIT_EMBEDDED_VERSION)
	echo "OVERRIDE_CC = $(TARGET_CC)" >> $(@D)/make.settings
	echo "OVERRIDE_AR = $(TARGET_AR)" >> $(@D)/make.settings
endef

define IOTKIT_EMBEDDED_CONFIGURE_CMDS
endef

define IOTKIT_EMBEDDED_BUILD_CMDS
	sed -i '41,43d' $(@D)/sample/mqtt/mqtt-example.c
	sed -i '41i #define PRODUCT_KEY $(BR2_PACKAGE_IOTKIT_EMBEDDED_PRODUCT_KEY)' \
		$(@D)/sample/mqtt/mqtt-example.c
	sed -i '41i #define DEVICE_NAME $(BR2_PACKAGE_IOTKIT_EMBEDDED_DEVICE_NAME)' \
		$(@D)/sample/mqtt/mqtt-example.c
	sed -i '41i #define DEVICE_SECRET $(BR2_PACKAGE_IOTKIT_EMBEDDED_DEVICE_SECRET)' \
		$(@D)/sample/mqtt/mqtt-example.c

	sed -i '32,34d' $(@D)/sample/mqtt/mqtt_multi_thread-example.c
	sed -i '32i #define PRODUCT_KEY $(BR2_PACKAGE_IOTKIT_EMBEDDED_PRODUCT_KEY)' \
		$(@D)/sample/mqtt/mqtt_multi_thread-example.c
	sed -i '32i #define DEVICE_NAME $(BR2_PACKAGE_IOTKIT_EMBEDDED_DEVICE_NAME)' \
		$(@D)/sample/mqtt/mqtt_multi_thread-example.c
	sed -i '32i #define DEVICE_SECRET $(BR2_PACKAGE_IOTKIT_EMBEDDED_DEVICE_SECRET)' \
		$(@D)/sample/mqtt/mqtt_multi_thread-example.c

	sed -i '27,29d' $(@D)/sample/mqtt/mqtt_rrpc-example.c
	sed -i '27i #define PRODUCT_KEY $(BR2_PACKAGE_IOTKIT_EMBEDDED_PRODUCT_KEY)' \
		$(@D)/sample/mqtt/mqtt_rrpc-example.c
	sed -i '27i #define DEVICE_NAME $(BR2_PACKAGE_IOTKIT_EMBEDDED_DEVICE_NAME)' \
		$(@D)/sample/mqtt/mqtt_rrpc-example.c
	sed -i '27i #define DEVICE_SECRET $(BR2_PACKAGE_IOTKIT_EMBEDDED_DEVICE_SECRET)' \
		$(@D)/sample/mqtt/mqtt_rrpc-example.c

	make -C $(@D) distclean
	make -C $(@D)
endef

define IOTKIT_EMBEDDED_INSTALL_TARGET_CMDS
	cp -f $(@D)/output/release/bin/mqtt* $(TARGET_DIR)/usr/bin
endef

# It's not autotools-based
$(eval $(generic-package))
$(eval $(host-generic-package))

