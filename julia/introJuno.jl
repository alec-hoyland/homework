using Juno

Juno.isactive()

Juno.structure(1:10)
Juno.structure(:(2x+1))

# test function
function myFunc()
    A = rand(200, 200, 400);
    maximum(A)
end

myFunc()

using Profile

@profiler myFunc()

Juno.progress() do id
    for i = 1:10
        sleep(0.5)
        @info "iterating" progress=i/10 _id=id
    end
end

@progress "aaa" 0.05 for i = 1:10
    sleep(0.5)
end
