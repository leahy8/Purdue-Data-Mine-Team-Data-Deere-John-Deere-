#Sources
#Dictionary to numpy array -> https://stackoverflow.com/questions/54021117/convert-dictionary-to-numpy-array
#https://www.w3schools.com/python/python_try_except.asp

#TODO
#Delete all rows with 0 - Done (Keep though?)
#Average out readings that occur in same county instead of overriding

import keras
import numpy as np
import json
import csv

state = "Iowa"
datasets = ['PRCP', 'TAVG', 'TMAX', 'TMIN'] #['AWND', 'EVAP', 'PRCP', 'TAVG', 'TMAX', 'TMIN']
trainYearsMin, trainYearsMax = 2002, 2010
testYearsMin, testYearsMax = 2011, 2012


trainYears = list(range(trainYearsMin,trainYearsMax + 1))
testYears = list(range(testYearsMin,testYearsMax + 1))
numInputs = 12 * len(datasets)

#Functions
def createDefaultEntry():
    temp = {}
    for name in datasets: #Each dataset
        for month in range(1,13): #For each month
            temp[f'{name}.{month}'] = 0 #Default values to 0 in case never filled out
    return temp

def loadDatasets():    
    x_train_dict, x_test_dict = {}, {}
    for datasetName in datasets:
        with open(f'../Data/{state}_GSOM_{datasetName}.json', 'r') as f: #Read in as dictionary
            mydict = json.load(f)   
            for entry in mydict.values(): #Convert to list and split based on year
                entryYear = int(entry['date'][0:4])
                entryMonth = int(entry['date'][5:7])
                entryCounty = str.upper(entry['county'][:-7]) #Format for later to match county
                keyName = f"{entryCounty}.{entryYear}" #Format for unique keys based on county and year

                if entryYear >= trainYearsMin and entryYear <= trainYearsMax:
                    if not keyName in x_train_dict:
                        x_train_dict[keyName] = createDefaultEntry()

                    x_train_dict[keyName][f'{datasetName}.{entryMonth}'] = entry['value']
                elif entryYear >= testYearsMin and entryYear <= testYearsMax:
                    if not keyName in x_test_dict:
                        x_test_dict[keyName] = createDefaultEntry()

                    x_test_dict[keyName][f'{datasetName}.{entryMonth}'] = entry['value']

    return x_train_dict, x_test_dict

def loadYield():
    y_train_dict, y_test_dict = {}, {}
    reader = csv.DictReader(open('../Data/Crop_Yield_County_NorthernMW_2002-12_modified.csv', 'r'))
    for line in reader:
        entryYear = int(line['Year'])
        entryCounty = line['County']
        keyName = f"{entryCounty}.{entryYear}" #Format for unique keys based on county and year
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
    #Interpolation Dict
    # { #JAN_PRCP    FEB_PRCP    MAR_PRCP
    #   {sum        sum         sum}
    #   {numPoints  numPoints   numPoints}
    # }
    inter_di = {}
    inter_di["sum"] = {}
    inter_di["num"] = {}
    inter_di["replace"] = {}

    #Interpolation Dict2
    # [ #Yield
    #   sum
    #   numPoints
    # ]
    inter_di2 = {}
    inter_di2["sum"] = 0
    inter_di2["num"] = 0
    inter_di2["replace"] = 0

    #Remove rows where more than 25% of data is missing
    #Sum up nonzero values for later interpolation
    di_final = {}
    for row_key in di.keys():
        row = di[row_key]
        numMissing = 0
        for key in row.keys():
            val = row[key]
            if val == 0:
                numMissing += 1
            else:
                if not key in inter_di["sum"]:#inter_di["sum"][key] == None:
                    inter_di["sum"][key] = 0
                    inter_di["num"][key] = 0
                inter_di["sum"][key] += val
                inter_di["num"][key] += 1
        
        if numMissing <= numInputs / 4:
            di_final[row_key] = row
    di = di_final

    #Sum up nonzero values for later interpolation
    for row in di2.values():
        if di != 0:
            inter_di2["sum"] += val #Sum
            inter_di2["num"] += 1 #Increment number of entries

    #Calculate replacement values
    for key in inter_di['num'].keys():
        inter_di["replace"][key] = inter_di["sum"][key] / inter_di["num"][key]

    inter_di2["replace"] = inter_di2["sum"] / inter_di2["num"] 

    #Interpolate missing values for remaining zeros
    for row_key in di.keys():
        row = di[row_key]
        for key in row.keys():
            if row[key] == 0:
                di[row_key][key] = inter_di["replace"][key]
    
    for key in di2.keys():
        if di2[key] == 0:
            di2[key] = inter_di2["replace"]

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


# Load in datasets
x_train_dict, x_test_dict = loadDatasets()
y_train_dict, y_test_dict = loadYield()

x_train_dict_clean, y_train_dict_clean = cleanDicts(x_train_dict, y_train_dict)
x_test_dict_clean, y_test_dict_clean = cleanDicts(x_test_dict, y_test_dict)

# Convert to Numpy Arrays
x_train = convertComplexDictToArray(x_train_dict_clean)
x_test = convertComplexDictToArray(x_test_dict_clean)
y_train = convertSimpleDictToArray(y_train_dict_clean)
y_test = convertSimpleDictToArray(y_test_dict_clean)

#See training data
np.savetxt('inputs.csv', x_train, delimiter=',', fmt='%.1f')
np.savetxt('outputs.csv', y_train, delimiter=',', fmt='%.1f')

#print(x_train)
#print(x_test)
#print(y_train)
#print(y_test)

# Normalize x values
x_train = keras.utils.normalize(x_train, axis=1)
x_test = keras.utils.normalize(x_test, axis=1)

#Define Model
model = keras.models.Sequential()
model.add(keras.layers.Dense(units=64, activation='relu', input_dim=numInputs))
model.add(keras.layers.Dense(units=64, activation='relu'))
model.add(keras.layers.Dense(units=1,  activation='linear'))

#Training
model.compile(optimizer='RMSprop', #RMSprop
              loss='mean_squared_error', #mean_absolute_error
              metrics=['mean_absolute_percentage_error']) #https://stackoverflow.com/questions/45632549/why-is-the-accuracy-for-my-keras-model-always-0-when-training

model.fit(x_train, y_train, epochs=10)

#Verify
val_loss, val_acc = model.evaluate(x_test, y_test)

#Output results
print("\n\t\t--Results--")
print(f"Loss:\t\t\t\t\t{val_loss:.3f}")
print(f"Mean Absolute Percentage Error:\t\t{val_acc:.2f}%")
print(f"Number of data points for training:\t{x_train.shape[0]}")
print(f"Number of data points for testing:\t{x_test.shape[0]}")

#Save
#model.save('Percent.model')


#Predictions
#predict_yields = model.predict(x_test)
#np.savetxt('Predict.csv', predict_yields, delimiter=',', fmt='%.1f')
#np.savetxt('Y_test.csv', y_test, delimiter=',', fmt='%.1f')