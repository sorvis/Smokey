import json
import urllib2
import urllib
import time

tfile = open("/sys/bus/w1/devices/28-000003e6cedf/w1_slave")
text = tfile.read()
tfile.close()
secondline = text.split("\n")[1]
temperaturedata = secondline.split(" ")[9]
temperature = float(temperaturedata[2:])
temperature = temperature / 1000

data = {
        'temperature_reading': {'CelciusReading': temperature}
}

req = urllib2.Request('http://server.com/temperature_readings.json')
req.add_header('Content-Type', 'application/json')

response = urllib2.urlopen(req, json.dumps(data))
print response

