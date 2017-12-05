import gpio
import time

for i in range(10, 14):
    gpio.setup(i, 'out')

for i in range(0, 100):
    for i in range(10, 14):
        gpio.set(i, 1)
        time.sleep(0.3)
    for i in range(10, 14):
        gpio.set(i, 0)
        time.sleep(0.3)
