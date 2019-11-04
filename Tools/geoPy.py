# geoPy
# Retrieves latitude and longitude based on a string of the location 
#
# @author - Ben Schwartz
# @date - 10/10/19

import time

from geopy.exc import GeocoderTimedOut, GeocoderQuotaExceeded
from geopy.geocoders import Nominatim
geolocator = Nominatim(user_agent="specify_your_app_name_here")


# Example
#location = geolocator.geocode("Boone County Iowa")
#print(location) #-> Boone County Iowa
#print((location.latitude, location.longitude)) #-> (42.052930, -93.795760)


def returnAfterComma(string, n):
    num = 0
    res = ""
    for i in string:
        if i == ",":
            num += 1
            if num > n:
                return res
            continue
        
        if num == n:
            res += i
    
    return "Error"


#https://gis.stackexchange.com/questions/173569/avoid-time-out-error-nominatim-geopy-open-street-maps
def do_geocode(address): #Never give up!
    try:
        return geolocator.geocode(address)
    except GeocoderTimedOut:
        time.sleep(2)
        return do_geocode(address)
    except GeocoderQuotaExceeded:
        time.sleep(10)
        print("Failed")
        return do_geocode(address)

with open("Crop_Yield_County_NorthernMW_2002-12.txt", "r") as readfile:
    with open("results.txt", "w") as writefile:
        currentLine = 0
        totalLines = len(readfile.readlines())
        readfile.seek(0)
        print(f"There are {totalLines} lines to analyze")

        runHeader = False
        for line in readfile.readlines():
            time.sleep(0.5)

            #Header
            if not runHeader:
                writefile.write(line[:-1] + ",Latitude,Longitude\n")
                runHeader = True
                continue

            county = returnAfterComma(line, 9)
            state = returnAfterComma(line, 5)

            locString = county + " COUNTY " + state
            location = do_geocode(locString)

            if location:
                writefile.write(line[:-1] + "," + str(location.latitude) + "," + str(location.longitude) + "\n")
            else:
                writefile.write(line[:-1] + ",,\n")

            currentLine += 1
            if currentLine % 100 == 0: #Print out every 100 lines
                print(f"{currentLine/totalLines:.2f}")
                time.sleep(10)

print("Done")