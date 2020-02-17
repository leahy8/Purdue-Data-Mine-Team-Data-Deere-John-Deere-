#Might be Keras 1.0? (Outdated)
#Tutorial: https://www.youtube.com/watch?v=wQ8BIBpya2k
#Article Version: https://pythonprogramming.net/introduction-deep-learning-python-tensorflow-keras/
import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt

mnist = tf.keras.datasets.mnist

(x_train, y_train), (x_test, y_test) = mnist.load_data()

x_train = tf.keras.utils.normalize(x_train, axis=1)
x_test = tf.keras.utils.normalize(x_test, axis=1)

#Define Model
model = tf.keras.models.Sequential()
model.add(tf.keras.layers.Flatten())
model.add(tf.keras.layers.Dense(128, activation=tf.nn.relu))
model.add(tf.keras.layers.Dense(128, activation=tf.nn.relu))
model.add(tf.keras.layers.Dense(10,  activation=tf.nn.softmax))

#Training
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

model.fit(x_train, y_train, epochs=3)

#Verify
val_loss, val_acc = model.evaluate(x_test, y_test)
print(val_loss)
print(val_acc)

#Save
model.save('num_reader.model')
#new_model = tf.keras.models.load_model('num_reader.model')

#Example Predict
predictions = model.predict([x_test])
print(predictions) #<- probability distributions
print(np.argmax(predictions[0])) #<- prediction for first entry is a 7 (returns 7)
#plt.imshow(x_test[0])
#plt.show()

# print()
# print()
# print(y_train)