import RPi.GPIO as GPIO
import time

# turn each on then off
def cycleSwitches(delay):
   for key in switches:
      GPIO.output(switches[key], True)
      time.sleep(delay)
      GPIO.output(switches[key], False)
      time.sleep(delay)

# Use GPIO numbering from board
GPIO.setmode(GPIO.BOARD)

# Setup hash of pins
switches = {1: 11, 2: 12, 3: 13, 4: 15}

# Setup switches to be outputs
for key in switches:
   GPIO.setup( switches[key], GPIO.OUT)

for i in range(1,30):
   delay = 1/float(i)
   print delay
   cycleSwitches(delay)   

