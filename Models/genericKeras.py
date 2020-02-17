from keras.models import Sequential #https://keras.io/
from keras.layers import Dense

model = Sequential() #Model Chose
model.add(Dense(units=64, activation='relu', input_dim=100)) #Add layers
model.add(Dense(units=10, activation='softmax'))

#Configure learning process
model.compile(loss='categorical_crossentropy',
              optimizer='sgd',
              metrics=['accuracy'])

#Alternative
#model.compile(loss=keras.losses.categorical_crossentropy,
#              optimizer=keras.optimizers.SGD(lr=0.01, momentum=0.9, nesterov=True))

#Iterate on training data in batches
# x_train and y_train are Numpy arrays --just like in the Scikit-Learn API.
model.fit(x_train, y_train, epochs=5, batch_size=32)
#model.train_on_batch(x_batch, y_batch) #OR - Feed model manually

#Evaluate Performance
loss_and_metrics = model.evaluate(x_test, y_test, batch_size=128)

#Predictions
classes = model.predict(x_test, batch_size=128)
