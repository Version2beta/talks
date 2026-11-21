import requests
import webbrowser
from bs4 import BeautifulSoup
from time import sleep

daves_lat = 41.980262
daves_lon = -87.668452
required_distance = 0.5/69

while True:
    r = requests.get('http://ctabustracker.com/bustime/map/getBusesForRoute.jsp?route=22')
    if r.status_code > 200:
        raise AssertionError
    doc = BeautifulSoup(r.text, "html5lib")
    buses = doc.findAll('bus')
    params = []
    markers = []
    done_looking = False
    for bus in buses:
        if bus.find('d').string.startswith('North'):
            bus_id = bus.find('id').string
            lat = float(bus.find('lat').string)
            lon = float(bus.find('lon').string)
            distance = abs(lat - daves_lat) * 69
            print "[bus %s] lat: %f, lon: %f, distance: %f miles" % (bus_id,  lat, lon, distance)
            if distance <= 0.75:
                params.append("markers=color:red|%s,%s" % (lat, lon))
                done_looking = True
    if done_looking:
        params.append("markers=color:blue|%s,%s" % (daves_lat, daves_lon))
        params.append("size=800x600")
        params.append("sensor=false")
        params.append("center=%f,%f" % (daves_lat, daves_lon))
        params.append("zoom=14")
        url = 'http://maps.googleapis.com/maps/api/staticmap?%s' % "&".join(params)
        webbrowser.open(url, autoraise=True)
        break
    else:
        sleep(10)

