import requests #https://realpython.com/python-requests/
import json
import tempfile

############################
######### Settings #########
############################
token = "RLvkdNZCbaPBqGykxdrqJPgHHMjdBkDx"
outputFileName = "MichiganPrecipitation" #Do not include .json, it will be added automatically

endpoint = "data"
requestParameters = {
    "locationid":   "FIPS:26",
    "datasetid":    "GSOM",
    "startdate":    "2002-01-01",
    "enddate":      "2012-12-31",
    "datatypeid":   "PRCP",
    "units":        "metric",
}


############################
######## Functions #########
############################
def genJSONFiles(requestParams, globalConstant, directoryName):
    #Generates JSON Files (regardless of limit) for the given years)

    #Get number of iterations needed
    requestParams["limit"] = "1000"
    requestParams['offset'] = '0'
    response = requests.get(
        f"https://www.ncdc.noaa.gov/cdo-web/api/v2/{endpoint}",
        params=requestParams,
        headers={'token': token},
    )

    maxRange = 0
    if not response:
        print('An error has occurred in retrieving metadata.')
    else:
        json_response = response.json()
        numResponses = json_response['metadata']['resultset']['count']
        print("Number of Responses: ", numResponses)

        maxRange = json_response['metadata']['resultset']['count'] // 1000 + 1

    #print(maxRange)

    for i in range(0, maxRange):
        with open(f"{directoryName}/{i + globalConstant}.json", "w") as writeFile:
            requestParams['offset'] = f"{i}001",

            response = requests.get(
                f"https://www.ncdc.noaa.gov/cdo-web/api/v2/{endpoint}",
                params=requestParams,
                headers={'token': token},
            )

            if response:
                json.dump(response.json(), writeFile)
                print(f'Success! Written temp file for responses {i}001-{i+1}000')
                #print(f'Success! Written file for {i + globalConstant}.json')
            else:
                print('An error has occurred.')

    return globalConstant + maxRange


def combineJSONFiles(globalConstant, directoryName):
    #Combines a series of json files
    files = []
    for i in range(0, globalConstant):
        files.append(f"{i}.json")

    entryNum = 1
    with open(outputFileName+".json", 'w') as writeFile:
        writeFile.write("{")
        for file1 in files:
            with open(f"{directoryName}/"+file1, "r") as read: 
                di = json.load(read)
            
                for dp in di['results']:
                    d = str(dp).replace("'", '"') #Replace with double quotes
                    res = f'"{entryNum}":{d},'  #Format entry number as key

                    if files[len(files) - 1] == file1 and di['results'][len(di['results']) - 1] == dp:
                        res = res[:-1] #Remove final comma

                    writeFile.write(res)
                    entryNum += 1
        writeFile.write("}")



############################
########### Main ###########
############################
globalConstant = 0

with tempfile.TemporaryDirectory() as directoryName:

    #Determine and split up intervals (Since a max of 10 years at a time)
    baseYear = int(requestParameters['startdate'][0:4])
    finalYear = int(requestParameters['enddate'][0:4])
    yearRange = finalYear - baseYear
    intervals = yearRange // 9
    finalInterval = yearRange % 9

    #9 Year intervals
    for z in range(intervals):
        startdate = str(baseYear + 9*z) + requestParameters['startdate'][4:]
        enddate = str(baseYear + 9*(z+1)) + requestParameters['startdate'][4:]
        rp = requestParameters.copy()
        rp['startdate'] = startdate
        rp['enddate'] = enddate

        print("\nRetrieving data between ", startdate, " and ", enddate)
        globalConstant = genJSONFiles(rp, globalConstant, directoryName)

    #Final interval
    startdate = str(baseYear + 9*intervals) + requestParameters['startdate'][4:]
    enddate = requestParameters['enddate']
    rp = requestParameters.copy()
    rp['startdate'] = startdate
    rp['enddate'] = enddate

    print("\nRetrieving data between ", startdate, " and ", enddate)
    globalConstant = genJSONFiles(rp, globalConstant, directoryName)



    # Combine all JSON Files
    combineJSONFiles(globalConstant, directoryName)

print("\nCleaning temporary directory")
print(f"Outputting file as {outputFileName}.json")