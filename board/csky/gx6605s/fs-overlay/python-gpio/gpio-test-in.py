import gpio
import time

for i in range(5, 9):
    gpio.setup(i, 'in')

while 1:
    time.sleep(1)
    for i in range(5, 9):
        gpio.read(i)
