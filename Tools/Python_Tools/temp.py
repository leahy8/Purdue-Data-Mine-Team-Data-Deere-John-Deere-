import re
import reverse_geocoder as rg #https://github.com/thampiman/reverse-geocoder

a = '"date": "2002-01-01T00:00:00", "datatype": "PRCP", "station": "GHCND:USC00113455", "attributes": ",,,0", "value": 30.3,"latitude": 40.8822,"longitude": -91.0233,"elevation": 164.0},"2":'

latitude = float(re.search('"latitude": (.*),"l', a).group(1))
longitude = float(re.search('"longitude": (.*),"e', a).group(1))

results = rg.search((latitude, longitude))
print(results)
print(type(results))

county = list(results[0].items())[4][1]
state = list(results[0].items())[3][1]


print(county)
print(state)

insertIndex = a.find("}")
print(insertIndex)
a = a[0:insertIndex] + f',"county": "{county}","state": "{state}"' + a[insertIndex:]
print(a)