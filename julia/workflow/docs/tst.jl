# put actual test code here
# load all the modules you need

include("Tmp.jl")
import .Tmp

Tmp.say_hello()
say_hello()

## alternatively, wrap test code in a module
# the advantage is that test code is contained within a module
# and does not use the global scope in Main for definitions
module Tst
    include("Tmp.jl")
    import .Tmp

    Tmp.say_hello()
    say_hello()
end
