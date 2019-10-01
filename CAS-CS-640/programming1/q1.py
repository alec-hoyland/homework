## Linear Data
# 1. Confusion matrix
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
X = np.genfromtxt('data/dataset1/LinearX.csv', delimiter=",")
y = np.genfromtxt('data/dataset1/LinearY.csv', delimiter=',')
y = y.astype(int)

config = Config()
config.nn_output_dim = 2

model = build_model(X, y, config, 3, print_loss=True)

def visualize(X, y, model):
    plt.scatter(X[:, 0], X[:, 1], c=y, cmap=plt.cm.Spectral)
    plt.show()
    plot_decision_boundary(lambda x:predict(model, x), X, y)
    plt.title("Linear Dataset")

visualize(X, y, model)

yhat = predict(model, X)

all_positives       = y == 1
all_negatives       = y == 0
true_positives      = 0
false_positives     = 0
true_negatives      = 0
false_negatives     = 0

for ii in range(0, len(X)):
    if y[ii] == 1 and yhat[ii] == 1:
        true_positives += 1
    if y[ii] == 1 and yhat[ii] == 0:
        false_negatives += 1
    if y[ii] == 0 and yhat[ii] == 0:
        true_negatives += 1
    if y[ii] == 0 and yhat[ii] == 1:
        false_positives += 1

precision = true_positives / (true_positives + false_positives)
recall = true_positives / sum(all_positives)
F1 = 2 * true_negatives / (2 * true_positives + false_positives + false_negatives)
accuracy = (true_positives + true_negatives) / (sum(all_positives) + sum(all_negatives))

print("true positives ", true_positives)
print("true negatives ", true_negatives)
print("false positives ", false_positives)
print("false negatives ", false_negatives)
print("precision ", precision)
print("recall ", recall)
print("F-1 score ", F1)
print("accuracy ", accuracy)
