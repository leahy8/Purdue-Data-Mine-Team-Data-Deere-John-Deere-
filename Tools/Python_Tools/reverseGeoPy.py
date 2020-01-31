import reverse_geocoder as rg #https://github.com/thampiman/reverse-geocoder
import re #For string searching https://stackoverflow.com/questions/3368969/find-string-between-two-substrings

states = ["Iowa", "Michigan", "Minnesota", "Wisconsin"]
datasets = ["AWND", "PRCP", "TAVG", "TMAX", "TMIN"] #"EVAP"

for state in states:
    for dataset in datasets:
        readFileName = f"Data/{state}_GSOM_{dataset}.json"
        writeFileName = f"Data/_{state}_GSOM_{dataset}.json"
        print(readFileName)

        with open(readFileName, "r") as readFile: #open("Data/Iowa_GSOM_PRCP.json", "r") as readFile:
            with open(writeFileName, "w") as writeFile:
                writeFile.write("{")
                entries = readFile.readline().split('{') #JSON file is single line, need to split entries with '{'
                #Example line for entry 1
                #"date": "2002-01-01T00:00:00", "datatype": "PRCP", "station": "GHCND:USC00113455", "attributes": ",,,0", "value": 30.3,"latitude": 40.8822,"longitude": -9
                #1.0233,"elevation": 164.0},"2":

                coordinateData = [] #stores coordinates
                #Add coordinates to data list, Ignore entries 0 and 1
                for entry in entries:
                    if entry[0:6] == '"date"': #Valid Line to change
                        latitude = float(re.search('"latitude": (.*),"l', entry).group(1))
                        longitude = float(re.search('"longitude": (.*),"e', entry).group(1))

                        coordinateData.append((latitude, longitude))


                results = rg.search(tuple(coordinateData)) #Use reverse_geocoder to find locations

                for i in range(1,len(entries)):
                    entry = entries[i]
                    if entry[0:6] == '"date"':
                        county = list(results[i-2].items())[4][1] #Parse out county and state, move back 2 because we ignore first 2 in entries
                        state = list(results[i-2].items())[3][1]

                        insertIndex = entry.find("}") #Add in results
                        entry = "{" + entry[0:insertIndex] + f',"county": "{county}","state": "{state}"' + entry[insertIndex:]


                    writeFile.write(entry)
                #writeFile.write("}")



# SUPER OLD AND SLOW WAY
# KEEPING IT AS A REMINDER THAT EVEN SUBTLE CHANGES IN CODE CAN BE THE DIFFERENCE BETWEEN 2 HOURS AND 2 SECONDS OF RUNTIME

# import reverse_geocoder as rg #https://github.com/thampiman/reverse-geocoder
# import re #For string searching https://stackoverflow.com/questions/3368969/find-string-between-two-substrings

# with open("use.json", "r") as readFile: #open("Data/Iowa_GSOM_PRCP.json", "r") as readFile:
#     with open("_res2.json", "w") as writeFile:
#         writeFile.write("{")
#         entries = readFile.readline().split('{') #JSON file is single line, need to split entries with '{'
#         #Example line for entry 1
#         #"date": "2002-01-01T00:00:00", "datatype": "PRCP", "station": "GHCND:USC00113455", "attributes": ",,,0", "value": 30.3,"latitude": 40.8822,"longitude": -9
#         #1.0233,"elevation": 164.0},"2":

#         #Ignore entries 0 and 1
#         for entry in entries:
#             if entry[0:6] == '"date"': #Valid Line to change
#                 #latitude = re.search('"latitude": (.*),', entry).group(1)
#                 #longitude = re.search('"longitude": (.*),', entry).group(1)
#                 latitude = float(re.search('"latitude": (.*),"l', entry).group(1))
#                 longitude = float(re.search('"longitude": (.*),"e', entry).group(1))

#                 results = rg.search((latitude, longitude)) #Use reverse_geocoder to find location

#                 county = list(results[0].items())[4][1] #Parse out county and state
#                 state = list(results[0].items())[3][1]

#                 insertIndex = entry.find("}") #Add in results
#                 entry = "{" + entry[0:insertIndex] + f',"county": "{county}","state": "{state}"' + entry[insertIndex:]


#             writeFile.write(entry)
#         writeFile.write("}")