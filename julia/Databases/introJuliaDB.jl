using JuliaDB

# create some vectors
x = [false, true, false, true]
y = ['B', 'B', 'A', 'A']
z = [0.1, 0.3, 0.2, 0.4]

## Tables

t1 = table(x, y, z)
t2 = table(x, y, z, names = [:x, :y, :z])
t3 = table(x, y, z, names = [:x, :y, :z], pkey = (:x, :y))

# build tables from named tuples
a = ("Josh", "Day")
b = (firstname = "Josh", lastname = "Day")
b.firstname
b[:firstname]

t4 = table((x = x, y = y, z = z), pkey = (:x, :y))
