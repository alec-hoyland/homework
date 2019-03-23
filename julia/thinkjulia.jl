## Excercise 6-5
# define the Ackermann function

function ack(m, n)
    @assert m >= 0 && n >= 0 "m and n must be nonnegative"
    if m == 0
        return n + 1
    elseif m > 0 && n == 0
        return ack(m-1, 1)
    else
        return ack(m-1, ack(m, n-1))
    end
end

ack(3,4)

## Exercise 6-6
# write a function to tell if a string is a palindrome

function ispalindrome(s)
    half = s[1:div(length(s), 2)]
    if isodd(length(s))
        mid  = s[length(half) + 1]
    else
        mid = ""
    end

    if s == half * mid * reverse(half)
        return true
    else
        return false
    end
end
