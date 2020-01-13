# combineJSON
# Combines multiple JSON files into one, specialized for JSON files retrieved using getPrecip.py
# 
# @author - Ben Schwartz
# @date - 10/20/19
import json

#Fill with file names to combine
files = []
for i in range(0, 30):
     files.append(f"WI_PRCP/WI_PRCP_{i}.json")

#Output File
outputFile = 'WI_PRCP/WI_PRCP.json'


result = []
entryNum = 1
with open(outputFile, 'w') as writeFile: #Create result file
    writeFile.write("{")
    for file1 in files: #Loop through each file that is being combined
        with open(file1, "r") as read: 
            di = json.load(read) #Read contents
        
            for dp in di['results']:
                d = str(dp).replace("'", '"') #Replace with double quotes
                res = f'"{entryNum}":{d},'  #Format entry number as key

                if files[len(files) - 1] == file1 and di['results'][len(di['results']) - 1] == dp:
                    res = res[:-1] #Remove final comma

                writeFile.write(res) #Write adjusted file to output file
                entryNum += 1
    writeFile.write("}")
