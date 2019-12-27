using Revise
using Example

# see that Example was correctly loaded
hello("world!")

# show that there isn't a function named f defined in Example
try
    Example.f()
catch
    "task failed successfully"
end

# open the module file
edit(hello)
# create a method named f
# f() = π

# f should be created and loaded even though we didn't reload the module
Example.f()

# this function f is specific to the version of the package we edited
