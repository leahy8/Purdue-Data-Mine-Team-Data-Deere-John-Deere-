#https://unidata.github.io/netcdf4-python/netCDF4/index.html#netCDF4.Dimension 
#https://www.researchgate.net/post/How_can_I_extract_data_from_NetCDF_file_by_python2 

import numpy as np
import datetime
from netCDF4 import Dataset, num2date, date2num
import json

#Helper Functions
def convertDateFormatToDays(date):
    return date2num(date, units='days since 1800-01-01 00:00:0.0')

def convertToDateFormat(days):
    return num2date(days, units='days since 1800-01-01 00:00:0.0')

#Settings
outputFile = 'Region_MOIT.json'
datatype = "MOIT"

#Time Specifications
startDate = datetime.datetime(2002, 1, 1) #'2002-01-01 00:00:0.0'
endDate = datetime.datetime(2012, 12, 1) #'2012-12-01 00:00:0.0'
startDay = convertDateFormatToDays(startDate)
endDay = convertDateFormatToDays(endDate)

startTimeIndex, endTimeIndex = 0, 0 #Set to global scope
startLatIndex, endLatIndex = 0, 0
startLonIndex, endLonIndex = 0, 0

# Lat and Long Specifications (specify region)
lat_min = 35 #degrees north #40
lat_max = 50 #50
lon_min = 360 - 100 #degrees west inputted on right (convert to degree east) #97
lon_max = 360 - 80

rootgrp = Dataset("soilw.mon.mean.v2.nc", "r", format="NETCDF4_CLASSIC")

##### Info about the file #####
print("Format: ", rootgrp.data_model)
print("Groups: ", rootgrp.groups)

for dimobj in rootgrp.dimensions.values(): #Info about each dimension
    print(dimobj)
#print(len(rootgrp['lat'])) #Latitude dimension

#print(rootgrp.variables)
for i in rootgrp.variables:
    print(i, '\t\t', rootgrp.variables[i].dtype, '\t\t', rootgrp.variables[i].units, '\t\t', rootgrp.variables[i].shape)

#d = np.array(rootgrp.variables['soilw'])

#print(rootgrp.variables['time'][:])
#print(rootgrp.variables['lat'][:])
#print(rootgrp.variables['lon'][:])
#print(rootgrp.variables['soilw'][:])


################## Find start and end index ##################
# Time (Increasing)
lookForStartIndex = True
for time_index in range(rootgrp.dimensions['time'].size):
    time = rootgrp.variables['time'][time_index]
    if lookForStartIndex and time >= startDay:
        startTimeIndex = time_index
        lookForStartIndex = False
    if time > endDay:
        endTimeIndex = min(rootgrp.dimensions['time'].size, time_index)
        break

# Latitude (Decreasing)
lookForStartIndex = True
for lat_index in range(rootgrp.dimensions['lat'].size):
    lat = rootgrp.variables['lat'][lat_index]
    if lookForStartIndex and lat <= lat_max:
        startLatIndex = lat_index + 1
        lookForStartIndex = False
    if lat < lat_min:
        endLatIndex = lat_index + 1
        break

# Longitude (Increasing)
lookForStartIndex = True
for lon_index in range(rootgrp.dimensions['lon'].size):
    lon = rootgrp.variables['lon'][lon_index]
    if lookForStartIndex and lon >= lon_min:
        startLonIndex = lon_index
        lookForStartIndex = False
    if lon > lon_max:
        endLonIndex = min(rootgrp.dimensions['lon'].size, lon_index)
        break

#print(endTimeIndex, startTimeIndex)
#print(endLatIndex, startLatIndex)
#print(endLonIndex, startLonIndex)
maxValues = (endTimeIndex - startTimeIndex) * (endLatIndex - startLatIndex) * (endLonIndex - startLonIndex)
print("Number of data points: ", maxValues)

##### Write to JSON file #####

with open(outputFile, 'w') as writeFile: #Create result file
    entryNum = 1
    writeFile.write("{")

    for time_index in range(startTimeIndex, endTimeIndex):
        time = rootgrp.variables['time'][time_index]
        for lat_index in range(startLatIndex, endLatIndex): #(rootgrp.dimensions['lat'].size):
            lat = rootgrp.variables['lat'][lat_index]
            for lon_index in range(startLonIndex, endLonIndex): #(rootgrp.dimensions['lon'].size):
                lon = rootgrp.variables['lon'][lon_index]
                val = rootgrp.variables['soilw'][time_index][lat_index][lon_index]
                date = convertToDateFormat(time)

                res = f'"{entryNum}":{{"date": "{date}","datatype": "{datatype}","value": {val},"latitude": {lat},"longitude": {lon-360},"elevation": 0}},'
                
                if (entryNum == maxValues):
                    res = res[:-1] #Remove final comma
                
                writeFile.write(res) #Write adjusted file to output file
                entryNum += 1

    
    writeFile.write("}")


rootgrp.close()