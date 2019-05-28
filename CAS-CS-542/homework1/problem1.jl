#%% ---
#%% title : Homework #1
#%% author : Alec Hoyland
#%% date : 2019-05-28
#%% options : 
#%%   doctype : md2html
#%% ---

#%% ## Introduction
#%% The goal is to design a simple algorithm that takes in a history of rock-paper-scissors
#%% and tries to guess the next winning choice.
#%% The data comes from 100 trials of a human playing RPS against the [essentially](https://www.essentially.net/rsp/end.jsp) algorithm.

cd("/home/alec/code/homework/CAS-CS-542/homework1/")

# compute results from the extant (unknown) algorithm
using CSV
using DataFrames
using StatsBase

#%% Here are the results from a user playing against the computer algorithm.
#%% A '1' indicates 'rock', '2' indicates 'paper', and '3' indicates a choice of 'scissors'.
results = CSV.read("data.csv", header = true)

function evaluateGame(x)
    score = [0, 0, 0]
    for ii in 1:size(x, 1)
        if x[ii,1] == x[ii, 2]
            # there is a tie
            score[3] += 1
        elseif x[ii, 1] == 3 & x[ii, 2] == 1
            # user wins
            score[1] += 1
        elseif x[ii, 1] < x[ii, 2] 
            # computer wins
            score[2] += 1
        else
            # user wins
            score[1] += 1
        end
    end
    return score
end

score = evaluateGame(results)

#%% In the first 100 trials against the computer,
#%% the player won `j score[1]` time, lost `j score[2]` times and tied `j score[3]` times.

#%% ## Naive algorithm
#%% This algorithm just picks a number between 1 and 3, corresponding to rock, paper, and scissors respectively.
#%% Therefore, in the long-time limit, victory vs. any other strategy will converge to ``\frac{1}{3}``.
#%% Even the wildly successful [iocaine powder](https://webdocs.cs.ualberta.ca/~darse/rsb-results1.html) algorithm
#%% reverts to random guessing in the case where the history-recognition algorithm fails.
#%% No strategy can beat the random-guessing one, however this is the trivial solution.
#%% If one's opponent is *not random*, there exist better algorithms.

function rps_alg_naive(history)
    return rand(1:3)
end
    
#%% ## Biased RPS algorithm
#%% This algorithm reads the history dependence and checks for bias in the opponent's guesses.
#%% If the opponent favors one sign over another, this algorithim will outperform random chance.
#%% This may not be true if the data set is poorly sampled.
#%% That is, if the user doesn't pick rock, paper, and scissors somewhat evenly.

function rps_alg_biased(history)
    counts = [sum(history[:,2] .== ii) for ii in 1:3]
    p = counts / sum(counts)
    return sample([1, 2, 3], Weights(p));
end

function rps_alg_biased(history, last_play)
    history = [history; last_play]
    rps_alg_biased(history)
end

#%% With the biased algorithm, I performed much better.
#%% I won 33 games, lost 25, and tied 42.
#%% As an enhancement to my algorithm, I allowed the dataset to grow with play.
#%% And recomputed the probabilities each time.

#%% ## Further considerations
#%% A more robust algorithm would look for more history dependence.
#%% For example, it would look for doublets and triplets that appear more commonly,
#%% and weight the probabilities higher when a triplet is recognized 
#%% (e.g. when you've seen two out of three just now).
#%% The dataset could be scraped for this information by finding all places where
#%% 1-2 exists and then finding what comes afterwards, in the case of the triplet 1-2-X.
