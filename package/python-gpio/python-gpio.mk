################################################################################
#
# python-gpio
#
################################################################################

PYTHON_GPIO_VERSION = 0.2.0
PYTHON_GPIO_SOURCE = gpio-$(PYTHON_GPIO_VERSION).tar.gz
PYTHON_GPIO_SITE = https://pypi.python.org/packages/62/27/020b5bab023f79100ad79d544239887e939f7c5dea7972f80c7fedc46be3
PYTHON_GPIO_LICENSE = MIT
PYTHON_GPIO_LICENSE_FILES = LICENCE.txt
PYTHON_GPIO_SETUP_TYPE = distutils

define PYTHON_GPIO_INSTALL
	rm $(TARGET_DIR)/python-gpio/ -rf
	mkdir $(TARGET_DIR)/python-gpio/ -p
	cp output/build/python-gpio-0.2.0/build/lib/gpio.py $(TARGET_DIR)/python-gpio/ -rf
endef

PYTHON_GPIO_POST_INSTALL_TARGET_HOOKS += PYTHON_GPIO_INSTALL

$(eval $(python-package))
