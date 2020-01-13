# geoPy
# Retrieves latitude and longitude based on a string of the location 
# Used to determine coordinates of a station when API only returns name of the location that the station is in 
# Reads a text file that was downloaded from the NOAA database, writes the result to a new text file
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
    #Input: String     Output: Subset of the String
    #Takes a string with entries that are separated by commas, such as "first,second,third"
    #Returns the entry after the nth commma
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
def do_geocode(address): #Repeatedly uses geopy package to determing the location of address until a return is successful
    try:
        return geolocator.geocode(address)
    except GeocoderTimedOut:
        time.sleep(2)
        return do_geocode(address)
    except GeocoderQuotaExceeded:
        time.sleep(10)
        print("Failed")
        return do_geocode(address)

with open("Crop_Yield_County_NorthernMW_2002-12.txt", "r") as readfile: #Input file
    with open("results.txt", "w") as writefile: #Output file
        currentLine = 0
        totalLines = len(readfile.readlines()) #Determine number of lines to analyze
        readfile.seek(0)
        print(f"There are {totalLines} lines to analyze")

        runHeader = False
        for line in readfile.readlines(): #Reads through each line
            time.sleep(0.5) #Waits half a second after each line to avoid throttling when using geopy

            #Header
            if not runHeader: #Writes the header only one time
                writefile.write(line[:-1] + ",Latitude,Longitude\n")
                runHeader = True
                continue

            county = returnAfterComma(line, 9)
            state = returnAfterComma(line, 5)

            locString = county + " COUNTY " + state  #Format county and state data as a single string for geopy
            location = do_geocode(locString)

            if location:
                writefile.write(line[:-1] + "," + str(location.latitude) + "," + str(location.longitude) + "\n") #Add coordinates if geopy was successful
            else:
                writefile.write(line[:-1] + ",,\n") #Write an empty entry if geopy returns nothing

            currentLine += 1
            if currentLine % 100 == 0: #Print out progress every 100 lines
                print(f"{currentLine/totalLines:.2f}")
                time.sleep(10)

print("Done")
