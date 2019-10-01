## MNIST Data
# 1. Confusion matrix (not sure if this concept is well-defined here)
# 2. Precision
# 3. Recall
# 4. F-1 Score
# 5. Accuracy
# 6. Decision boundary decision boundary

from nnet import *
import matplotlib.pyplot as plt
import numpy as np
import sklearn
import sklearn.datasets
import sklearn.linear_model
import matplotlib

# load the dataset
X = np.genfromtxt('data/dataset2/Digit_X_train.csv', delimiter=",")
y = np.genfromtxt('data/dataset2/Digit_y_train.csv', delimiter=',')
y = y.astype(int)

# load the test dataset
X_test = np.genfromtxt('data/dataset2/Digit_X_test.csv', delimiter=",")
y_test = np.genfromtxt('data/dataset2/Digit_y_test.csv', delimiter=",")

def visualize(X, y, model):
    plt.scatter(X[:, 0], X[:, 1], c=y, cmap=plt.cm.Spectral)
    plt.show()
    plot_decision_boundary(lambda x:predict(model, x), X, y)
    plt.title("Linear Dataset")

def evaluateResults(y_test, yhat):

    # all_positives       = y == 1
    # all_negatives       = y == 0
    # true_positives      = 0
    # false_positives     = 0
    # true_negatives      = 0
    # false_negatives     = 0
    #
    # for ii in range(0, len(X)):
    #     if y[ii] == 1 and yhat[ii] == 1:
    #         true_positives += 1
    #     if y[ii] == 1 and yhat[ii] == 0:
    #         false_negatives += 1
    #     if y[ii] == 0 and yhat[ii] == 0:
    #         true_negatives += 1
    #     if y[ii] == 0 and yhat[ii] == 1:
    #         false_positives += 1
    #
    # precision = true_positives / (true_positives + false_positives)
    # recall = true_positives / sum(all_positives)
    # F1 = 2 * true_negatives / (2 * true_positives + false_positives + false_negatives)
    # accuracy = (true_positives + true_negatives) / (sum(all_positives) + sum(all_negatives))

    print("-----------------")
    print("accuracy: ", sum(yhat == y_test) / len(y))
    print(" ")

config = Config()
config.nn_input_dim = 64  # input layer dimensionality
config.nn_output_dim = 10  # output layer dimensionality
config.epsilon = 0.001  # learning rate for gradient descent
config.reg_lambda = 0.01  # regularization strength

model = build_model(X, y, config, 100, num_passes=20000, print_loss=False)
# visualize(X, y, model)
yhat = predict(model, X_test)

## Varying number of neurons
nNodes = [10, 30, 100, 200, 300]

for node_num in nNodes:
    model = build_model(X, y, config, node_num, num_passes=20000, print_loss=False)
    # visualize(X, y, model)
    yhat = predict(model, X_test)
    print("Number of Neurons: ", node_num)
    evaluateResults(y_test, yhat)

## Varying the regularization coefficient
reg_lambda = [0.001, 0.003, 0.01, 0.03, 0.1]

for reg_coeff in reg_lambda:
    config.reg_lambda = reg_coeff
    model = build_model(X, y, config, 100, num_passes=20000, print_loss=False)
    # visualize(X, y, model)
    yhat = predict(model, X_test)
    print("Regularization Coefficient: ", reg_coeff)
    evaluateResults(y_test, yhat)

## Varying the learning rate
config.reg_lambda = 0.01
learning_rate = [0.0001, 0.0003, 0.003, 0.001, 0.003]

for lrate in learning_rate:
    config.epsilon = lrate
    model = build_model(X, y, config, 100, num_passes=20000, print_loss=False)
    # visualize(X, y, model)
    yhat = predict(model, X_test)
    print("Learning Rate: ", lrate)
    evaluateResults(y_test, yhat)

## Varying the number of epochs
config.learning_rate = 0.001
num_epochs = [100, 200, 2000, 10000, 20000]

for ii in num_epochs:
    model = build_model(X, y, config, 100, num_passes=ii, print_loss=False)
    # visualize(X, y, model)
    yhat = predict(model, X_test)
    print("Number of Epochs: ", ii)
    evaluateResults(y_test, yhat)
