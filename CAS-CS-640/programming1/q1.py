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
data = np.genfromtxt('data/dataset1/LinearX.csv', delimiter=",")

config = Config()
config.nn_output_dim = 1
