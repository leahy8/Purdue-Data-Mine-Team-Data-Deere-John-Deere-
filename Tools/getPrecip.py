# getPrecip
# Retrieves precipitation data from NOAA's web api and stores it as JSON files 
# Repeats requests for multiple states 
#
# @author - Ben Schwartz
# @date - 10/14/19
import requests #https://realpython.com/python-requests/
import json

token = "RLvkdNZCbaPBqGykxdrqJPgHHMjdBkDx"

#Michigan  - FIPS:26
#Minnesota - FIPS:27
#Iowa      - FIPS:19
#Wisconsin - FIPS:55

states = [
    ["Michigan",    "MI",  "FIPS:26", 0, 29], #Metadata says there are 28,880 responses
    ["Minnesota",   "MN",  "FIPS:27", 0, 25], #24477 entries
    ["Iowa",        "IA",  "FIPS:19", 0, 27], #26522
    ["Wisconsin",   "WI",  "FIPS:55", 0, 30], #29641
]

#with open("MI_PRCP/test.json", "w"):
#    pass

for state in states:
    print(state[0])
    stateCode = state[1]
    fip = state[2]
    start = state[3]
    stop = state[4]

    for i in range(start, stop):  
        with open(f"{stateCode}_PRCP/{stateCode}_PRCP_{i}.json", "w") as writeFile:
            response = requests.get(
                "https://www.ncdc.noaa.gov/cdo-web/api/v2/data",
                params={
                    "locationid":   fip,#"FIPS:26",
                    "datasetid":    "GSOM",
                    "startdate":    "2002-01-01",
                    "enddate":      "2012-01-01",
                    "limit":        "1000",
                    "datatypeid":   "PRCP",
                    "units":        "metric",
                    "offset":       f"{i}001",
                },
                headers={'token': token},
            )

            if response:
                json.dump(response.json(), writeFile)
                print(f'Success! Written file for {stateCode}_PRCP_{i}.json')
            else:
                print('An error has occurred.')
