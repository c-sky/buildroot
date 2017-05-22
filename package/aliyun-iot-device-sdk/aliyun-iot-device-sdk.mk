################################################################################
#
# aliyun-iot-device-sdk
#
################################################################################

ALIYUN_IOT_DEVICE_SDK_VERSION = c-2017-05-11
ALIYUN_IOT_DEVICE_SDK_SOURCE = aliyun-iot-device-sdk-$(ALIYUN_IOT_DEVICE_SDK_VERSION).zip
ALIYUN_IOT_DEVICE_SDK_SITE = http://aliyun-iot.oss-cn-hangzhou.aliyuncs.com
ALIYUN_IOT_DEVICE_SDK_LICENSE = EPL-1.0 or EDLv1.0

define ALIYUN_IOT_DEVICE_SDK_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(DL_DIR)/$(ALIYUN_IOT_DEVICE_SDK_SOURCE)
	mv $(@D)/aliyun-iot-device-sdk-$(ALIYUN_IOT_DEVICE_SDK_VERSION)/* $(@D)
	$(RM) -r $(@D)/aliyun-iot-device-sdk-$(ALIYUN_IOT_DEVICE_SDK_VERSION)
	echo "PLATFORM_CC = $(TARGET_CC)" >> $(@D)/make.settings
	echo "PLATFORM_AR = $(TARGET_AR)" >> $(@D)/make.settings
endef

define ALIYUN_IOT_DEVICE_SDK_CONFIGURE_CMDS
endef

define ALIYUN_IOT_DEVICE_SDK_BUILD_CMDS
	sed -i '10,13d' $(@D)/examples/linux/mqtt/demo.c
	sed -i '10i #define PRODUCT_KEY $(BR2_PACKAGE_ALIYUN_IOT_DEVICE_SDK_PRODUCT_KEY)' \
		$(@D)/examples/linux/mqtt/demo.c
	sed -i '10i #define PRODUCT_SECRET $(BR2_PACKAGE_ALIYUN_IOT_DEVICE_SDK_PRODUCT_SECRET)' \
		$(@D)/examples/linux/mqtt/demo.c
	sed -i '10i #define DEVICE_NAME $(BR2_PACKAGE_ALIYUN_IOT_DEVICE_SDK_DEVICE_NAME)' \
		$(@D)/examples/linux/mqtt/demo.c
	sed -i '10i #define DEVICE_SECRET $(BR2_PACKAGE_ALIYUN_IOT_DEVICE_SDK_DEVICE_SECRET)' \
		$(@D)/examples/linux/mqtt/demo.c
	make -C $(@D)
endef

define ALIYUN_IOT_DEVICE_SDK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/aliyun-iot-device-sdk/examples/linux/mqtt/
	cp -f $(@D)/examples/linux/mqtt/demo $(TARGET_DIR)/aliyun-iot-device-sdk/examples/linux/mqtt/demo
endef

# It's not autotools-based
$(eval $(generic-package))
$(eval $(host-generic-package))
