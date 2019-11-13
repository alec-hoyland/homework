## a fully-connected neural network

# preamble
using Flux, Flux.Data.MNIST, Statistics
using Flux: onehotbatch, onecold, crossentropy, throttle
using Base.Iterators: repeated

## Model definition

model = Chain(
    Dense(28^2, 32, relu),
    Dense(32, 10),
    softmax)

loss(x, y) = crossentropy(model(x), y)
accuracy(x, y) = mean(onecold(model(x) .== onecold(y)))

function training_naive(loss, model, training_set; mods=false, filename="mnist_nn.bson")
    @info "Beginning training loop"
    best_accuracy = 0.0
    last_improvement = 0

    for epoch_idx in 1:100
        global best_accuracy, last_improvement

        # train for a single epoch
        Flux.train!(loss, params(model), training_set, ADAM(0.001))

        # calculate accuracy
        this_accuracy = accuracy(test_set...)
        @info(@sprintf("[%d]: Test accuracy: %.4f", epoch_idx, this_accuracy))

        if mod == true
            # add early-stopping to see if we can improve the model

            # if accuracy > 99.9%, exit training
            if acc >= 0.999
                @info("Accuracy is at least 99.9%, early-exiting")
                break
            end

            # compare this accuracy to best accuracy
            if acc >= best_acc
                @info("New best accuracy! Saving model to $filename")
                BSON.@save joinpath(dirname(@__FILE__), "$filename") model epoch_idx acc
                best_acc = acc
                last_improvement = epoch_idx
            end

            # adaptive learning rate
            if epoch_idx - last_improvement >= 5 && opt.eta > 1e-6
                opt.eta /= 10.0
                @warn("No improvement seen recently, dropping the learning rate to $(opt.eta)!")
            end

            # stop training if model has converged
            if epoch_idx - last_improvement >= 10
                @warn("Model has converged, stopping training.")
                break
            end

        end

    end
end
