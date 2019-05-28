# ---
# title : Homework #1
# author : Alec Hoyland
# date : 2019-05-28
# options : 
#   out_path : CAS-CS-542/homework1/problem1.pdf
#   doctype : md2pdf
# ---

## Write a simple algorithm that tries to play Rock-Paper-Scissors (and win!)
cd("/home/alec/code/homework/CAS-CS-542/homework1/")

# compute results from the extant (unknown) algorithm
using CSV
using DataFrames

results = CSV.read("data.csv", header = false)

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

# in the first game against the computer
score = evaluateGame(results)

print("")
