import keras
import numpy as np
import json
import csv

state = "Illinois"
datasets = ['PRCP', 'TAVG', 'TMAX', 'TMIN'] 

trainYearsMin, trainYearsMax = 0, 0
testYearsMin, testYearsMax = 2002, 2012

model = keras.models.load_model('currentModel.model')

addInSoilMoistureData = False
################################################################################################################
################################################################################################################
#Functions
def createDefaultEntry():
    temp = {}
    for name in datasets: #Each dataset
        for month in range(1,13): #For each month
            temp[f'{name}.{month}'] = 0 #Default values to 0 in case never filled out

    if addInSoilMoistureData:
         for month in range(1,13):
            temp[f'MOIT.{month}'] = 0

    return temp

def readInFile(fileName, datasetName, x_train_dict, x_test_dict):
    with open(fileName, 'r') as f: #Read in as dictionary
        mydict = json.load(f)   
        for entry in mydict.values(): #Convert to list and split based on year
            entryYear = int(entry['date'][0:4])
            entryMonth = int(entry['date'][5:7])
            entryCounty = str.upper(entry['county'][:-7]) #Format for later to match county
            entryState = str.upper(entry['state'])
            keyName = f"{entryState}.{entryCounty}.{entryYear}" #Format for unique keys based on county and year

            if entryYear >= trainYearsMin and entryYear <= trainYearsMax:
                if not keyName in x_train_dict:
                    x_train_dict[keyName] = createDefaultEntry()

                x_train_dict[keyName][f'{datasetName}.{entryMonth}'] = entry['value']
            elif entryYear >= testYearsMin and entryYear <= testYearsMax:
                if not keyName in x_test_dict:
                    x_test_dict[keyName] = createDefaultEntry()

                x_test_dict[keyName][f'{datasetName}.{entryMonth}'] = entry['value']
    return x_train_dict, x_test_dict

def loadDatasets():    
    x_train_dict, x_test_dict = {}, {}
    for datasetName in datasets:
        x_train_dict, x_test_dict = readInFile(f'../Data/{state}_GSOM_{datasetName}.json', datasetName, x_train_dict, x_test_dict)

    if addInSoilMoistureData:
        x_train_dict, x_test_dict = readInFile('../Data/Region_MOIT_updated.json', 'MOIT', x_train_dict, x_test_dict) #Read in soil moisture

    return x_train_dict, x_test_dict

def loadYield():
    y_train_dict, y_test_dict = {}, {}
    reader = csv.DictReader(open('../Data/Crop_Yield_County_NorthernMW_2002-12_modified.csv', 'r'))
    for line in reader:
        entryYear = int(line['Year'])
        entryCounty = line['County']
        entryState = line['State']
        keyName = f"{entryState}.{entryCounty}.{entryYear}" #Format for unique keys based on county and year

        if entryYear >= trainYearsMin and entryYear <= trainYearsMax:
            if not keyName in y_train_dict:
                y_train_dict[keyName] = 0

            y_train_dict[keyName]= float(line['Value'])
        elif entryYear >= testYearsMin and entryYear <= testYearsMax:
            if not keyName in y_test_dict:
                y_test_dict[keyName] = 0

            y_test_dict[keyName] = float(line['Value'])

    return y_train_dict, y_test_dict

def cleanDicts(di, di2):
    #Remove rows where literal value is 0
    di = {x:di[x] for x in di if di[x] !=  0} 
    di2 = {x:di2[x] for x in di2 if di2[x] !=  0}

    #Remove rows where value (a dictionary) has a 0 in it
    try:
        di = {x:di[x] for x in di if not 0 in di[x].values()} 
    except:
        pass

    try:
        di2 = {x:di2[x] for x in di2 if not 0 in di2[x].values()}
    except:
        pass

    #Keeps entries only if in both dictionaries
    di = {x:di[x] for x in di if x in di2} 
    di2 = {x:di2[x] for x in di2 if x in di}

    return di, di2

def convertComplexDictToArray(mydict): #Used for nested dictionaries
    ## X TRAINING STRUCTURE
    # NUMPY ARRAY
    #               awnd.month1 evap.. prcp.. tavg.. tmax.. tmin.. awnd.month2
    # county a.year[[ 1         2      3      4      5      6      7]
    # county b.year [ 3         5      9      8      4      8      8]]
    return np.array([list(item.values()) for item in mydict.values()]) 

def convertSimpleDictToArray(mydict): #Used for dictionary with simple key value pairs
    ## Y TRAINING STRUCTURE
    # NUMPY ARRAY
    #               yield 
    # county a.year[ 120
    # county b.year  130 ]
    return np.array([item for item in mydict.values()])
################################################################################################################
################################################################################################################
################################################################################################################

# Load in datasets
_, x_test_dict = loadDatasets()
_, y_test_dict = loadYield()

x_test_dict_clean, y_test_dict_clean = cleanDicts(x_test_dict, y_test_dict)

# Convert to Numpy Arrays
x_test = convertComplexDictToArray(x_test_dict_clean)
y_test = convertSimpleDictToArray(y_test_dict_clean)

# Normalize x values
x_test = keras.utils.normalize(x_test, axis=1)


# Verify & Output Results
val_loss, val_acc = model.evaluate(x_test, y_test)

print("\n\t\t--Results--")
print(f"Loss:\t\t\t\t\t{val_loss:.3f}")
print(f"Mean Absolute Percentage Error:\t\t{val_acc:.2f}%")
print(f"Number of data points for verifying:\t{x_test.shape[0]}")