import json
import urllib2
import urllib
import time

data = {
                'temperature_reading': {'CelciusReading': 23,
                              'external_device_id': '28-0000065cd57a'}
                }
print data

req = urllib2.Request('http://localhost:3000/temperature_readings.json')
req.add_header('Content-Type', 'application/json')

response = urllib2.urlopen(req, json.dumps(data))
print response

