# Programming Assignment 1
CS 640 Programming Assignment 1

**Author:** Alec Hoyland

**Date**: 2019-10-1 13:28

## How my neural network classifies data
My neural network consists of an input layer, a hidden layer, and an output layer.
I use a cross-entropy cost loss function with L2 regularization.
The network is fully-connected and feedforward,
with a hyperbolic tangent activation function.

There are three hyperparameters: the number of nodes in the hidden network,
the learning rate (epsilon), and the regularization coefficient (lambda).

Data are passed into the first layer, which has one node per feature of the input data.
The values are passed from the input nodes to the hidden layer nodes
according to some weights. This is a dot product between a weight matrix and a value vector.
The hidden nodes perform a nonlinear transformation
by the activation function, tanh.
Then, a second set of weights maps the output of the hidden layer to the output layer.

I compute the output probability using a soft argmax function.
These probabilities are degrees of belief that the input is in class 1 or class 2, or so on.
There is one probability value per class.

## Forward propagation
The inputs are dot-multiplied by weight matrix between the first and second layers,
to which the second layer bias is added.
This is transformed by the tanh activation function.
This process is repeated, where the new vector is dot-multiplied by the weight matrix
between the second and third layers, and the third layer bias is added.
Probabilities are computed using the soft argmax function.

```python
# Forward propagation
z1 = X.dot(W1) + b1
a1 = np.tanh(z1)
z2 = a1.dot(W2) + b2
exp_scores = np.exp(z2)
probs = exp_scores / np.sum(exp_scores, axis=1, keepdims=True)
```

## Backpropagation
Each individual weight must be changed by an amount equal to the learning rate times
the partial derivative of the loss function by the individual weight.
Since this is a multi-layer network, the error derivatives propagate backwards
according to the chain rule.

I compute the error by taking the output probabilities and subtracting the real result.
The second to third layer weight "gradient" is computed as the dot product
between the second layer activated values and the third layer error.
The first to second layer weight "gradient" is computer as a dot product
between the third layer weight "gradient", the second to third layer weights,
and the derivative of the activation function evaluated
on the second layer activated values.

The bias terms also change values, but simply by the sum of the computed errors,
since the bias terms are added (they aren't multiplied by the weight matrix).

Regularization affects the weight error,
by penalizing when weights get large.

All weights and biases are then decreased by the learning rate times the
backpropagated error.

```python
# Backpropagation
delta3 = probs
delta3[range(num_examples), y] -= 1
dW2 = (a1.T).dot(delta3)
db2 = np.sum(delta3, axis=0, keepdims=True)
delta2 = delta3.dot(W2.T) * (1 - np.power(a1, 2))
dW1 = np.dot(X.T, delta2)
db1 = np.sum(delta2, axis=0)

# regularization
dW2 += config.reg_lambda * W2
dW1 += config.reg_lambda * W1

# Gradient descent parameter update
W1 += -config.epsilon * dW1
b1 += -config.epsilon * db1
W2 += -config.epsilon * dW2
b2 += -config.epsilon * db2
```

## Linear Dataset
I used my neural network on the linear dataset provided.
I used a learning rate of 0.01,
regularization lambda of 0.01,
and 3 nodes in the hidden layer.

```
true positives  231
true negatives  242
false positives  8
false negatives  19
precision  0.9665271966527197
recall  0.924
F-1 score  0.9897750511247444
accuracy  0.946
```

![](q1.png)
