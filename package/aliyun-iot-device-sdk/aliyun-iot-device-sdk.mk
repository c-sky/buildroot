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
	make -C $(@D)
endef

define ALIYUN_IOT_DEVICE_SDK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/aliyun-iot-device-sdk/examples/linux/mqtt/
	cp -f $(@D)/examples/linux/mqtt/demo $(TARGET_DIR)/aliyun-iot-device-sdk/examples/linux/mqtt/demo
endef

# It's not autotools-based
$(eval $(generic-package))
$(eval $(host-generic-package))
