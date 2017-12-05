import gpio
import time

for i in range(5, 10):
    gpio.setup(i, 'in')

while 1:
    time.sleep(0.1)
    for i in range(5, 10):
        val = gpio.read(i)
        if val == 0:
            print "pin: %d" %i
