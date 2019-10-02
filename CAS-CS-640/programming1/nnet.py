import numpy as np
import matplotlib.pyplot as plt


# hold onto some parameters
class Config:
    nn_input_dim = 2
    nn_output_dim = 2
    epsilon = 0.01 # learning rate
    reg_lambda = 0.01

# I wasn't sure how to do this, so I grabbed this function from the internet
# https://github.com/dennybritz/nn-from-scratch/blob/0b52553c84c8bd5fed4f0c890c98af802e9705e9/nn_from_scratch.py#L27
def plot_decision_boundary(pred_func, X, y):
    # Set min and max values and give it some padding
    x_min, x_max = X[:, 0].min() - .5, X[:, 0].max() + .5
    y_min, y_max = X[:, 1].min() - .5, X[:, 1].max() + .5
    h = 0.01
    # Generate a grid of points with distance h between them
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    # Predict the function value for the whole gid
    Z = pred_func(np.c_[xx.ravel(), yy.ravel()])
    Z = Z.reshape(xx.shape)
    # Plot the contour and training examples
    plt.contourf(xx, yy, Z, cmap=plt.cm.Spectral)
    plt.scatter(X[:, 0], X[:, 1], c=y, cmap=plt.cm.Spectral)
    plt.show()


def calculate_loss(model, X, y):
    """ evaluates the loss, for printing during training """
    nExamples = len(X)  # training set size
    W1, b1, W2, b2 = model['W1'], model['b1'], model['W2'], model['b2']
    # Forward propagation
    z1 = X.dot(W1) + b1
    a1 = np.tanh(z1)
    z2 = a1.dot(W2) + b2
    these_scores = np.exp(z2)
    these_p = these_scores / np.sum(these_scores, axis=1, keepdims=True)
    # Calculating the loss
    log_p = -np.log(these_p[range(nExamples), y])
    data_loss = np.sum(log_p)
    # Add regularization term to loss
    # This is the L2 norm with coefficient reg_lambda/2
    data_loss += Config.reg_lambda / 2 * (np.sum(np.square(W1)) + np.sum(np.square(W2)))
    return 1. / nExamples * data_loss


def predict(model, x):
    """ use a trained model to predict, based on input x """
    W1, b1, W2, b2 = model['W1'], model['b1'], model['W2'], model['b2']
    # Forward propagation
    z1 = x.dot(W1) + b1
    a1 = np.tanh(z1)
    z2 = a1.dot(W2) + b2
    these_scores = np.exp(z2)
    # soft argmax output
    these_p = these_scores / np.sum(these_scores, axis=1, keepdims=True)
    return np.argmax(these_p, axis=1)

def build_model(X, y, config, nn_hdim, num_passes=20000, print_loss=False):
    """ build a model and train it """
    nExamples = len(X)
    # be consistent with the randomness
    np.random.seed(0)
    # set up the parameters with random values, drawn from the normal distribution
    # parameters are normalized/scaled by the square root of the input dimensionality
    # to keep the input to a given hidden/output node small
    W1 = np.random.randn(config.nn_input_dim, nn_hdim) / np.sqrt(config.nn_input_dim)
    b1 = np.zeros((1, nn_hdim))
    W2 = np.random.randn(nn_hdim, config.nn_output_dim) / np.sqrt(nn_hdim)
    b2 = np.zeros((1, config.nn_output_dim))

    # initialize outputs
    model = {}

    # gradient descent, over num_passes epochs
    for i in range(0, num_passes):

        ## Forward propagation
        z1 = X.dot(W1) + b1
        a1 = np.tanh(z1)
        z2 = a1.dot(W2) + b2
        these_scores = np.exp(z2)
        these_p = these_scores / np.sum(these_scores, axis=1, keepdims=True)

        ## Backpropagation
        delta3 = these_p
        # clever hack for one-hot data
        delta3[range(nExamples), y] -= 1
        # compute the "gradient" of the output weights
        dW2 = (a1.T).dot(delta3)
        # compute the "gradient" of the output biases
        db2 = np.sum(delta3, axis=0, keepdims=True)
        # compute the errors for the hidden layer
        # output errors times the derivative of the activation function
        delta2 = delta3.dot(W2.T) * (1 - np.power(a1, 2))
        # compute the "gradient" of the hidden layer weights
        dW1 = np.dot(X.T, delta2)
        # compute the "gradient" of the hidden layer biases
        db1 = np.sum(delta2, axis=0)

        ## Add regularization terms
        # I didn't add any regularization to biases, I think this is fine...
        dW2 += config.reg_lambda * W2
        dW1 += config.reg_lambda * W1

        ## Gradient descent parameter update step
        W1 += -config.epsilon * dW1
        b1 += -config.epsilon * db1
        W2 += -config.epsilon * dW2
        b2 += -config.epsilon * db2

        ## Update model
        model = {'W1': W1, 'b1': b1, 'W2': W2, 'b2': b2}

        # do you want to print the loss?
        if print_loss and i % 1000 == 0:
            print("Loss after iteration %i: %f" % (i, calculate_loss(model, X, y)))

    return model
