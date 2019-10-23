import json

#Fill with file names to combine
files = []
for i in range(0, 30):
     files.append(f"WI_PRCP/WI_PRCP_{i}.json")

#Output File
outputFile = 'WI_PRCP/WI_PRCP.json'


result = []
entryNum = 1
with open(outputFile, 'w') as writeFile:
    writeFile.write("{")
    for file1 in files:
        with open(file1, "r") as read: 
            di = json.load(read)
        
            for dp in di['results']:
                d = str(dp).replace("'", '"') #Replace with double quotes
                res = f'"{entryNum}":{d},'  #Format entry number as key

                if files[len(files) - 1] == file1 and di['results'][len(di['results']) - 1] == dp:
                    res = res[:-1] #Remove final comma

                writeFile.write(res)
                entryNum += 1
    writeFile.write("}")




#print()
#print(result)

######with open('WI_PRCP/WI_PRCP.json', 'w') as write:
#with open('result.json', 'w') as write:
#    json.dump(result, write)
    ######write.write(str(result))




#Before converting from dict to array
#     #from jsonmerge import merge
# import json

# #files = ['testA.json', 'testB.json', 'testC.json']
# files = []
# for i in range(0, 1):#24):
#      files.append(f"WI_PRCP/WI_PRCP_{i}.json")


# #def addJSONFile(result, fileName):
# #    with open(file, "r") as read:  
# #        di = json.dumps(read.readlines())
# #        #global result      
# #        #result = merge(read.readlines(), result)
# #        #print(result)
# #        return {}#result.update(di)

# result = {}
# for file in files:
#     with open(file, "r") as read: 
#         di = json.load(read)#json.loads(json.dumps(read.readlines()))
#         print(di['results'][0])
#         result.update(di['results']) #addJSONFile(result, file)
#         #print(result)

# #print()
# #print(result)

# #with open('WI_PRCP/WI_PRCP.json', 'w') as write:
# with open('result.json', 'w') as write:
#     json.dump(result, write)
#     #write.write(str(result))








#Only works for new line for each thing
# import os

# #files = ['testA.json', 'testB.json', 'testC.json']
# files = []

# for i in range(0, 29):
#     files.append(f"MI_PRCP/MI_PRCP_{i}.json")

# with open('MI_PRCP/MI_PRCP.json', 'w') as writeFile:
#     writeFile.write("{\n")
#     for file in files:
#         with open(file) as readFile:
#             foundResults = False
#             for line in readFile:
#                 print(len(line))
#                 #Skip through until results
#                 if not foundResults:
#                     if line.find('"results": [{') != -1: 
#                         foundResults = True
#                     continue
                
#                 #No more results
#                 if line.find("}]") != -1: 
#                     if file != files[len(files) - 1]:
#                         writeFile.write(",\n")
#                     break

#                 #print(line)
#                 writeFile.write(line)

#     writeFile.write("}")