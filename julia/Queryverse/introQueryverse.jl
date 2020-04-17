using Queryverse, VegaDatasets, IndexedTables

# load a dataset from Vega
cars = dataset("cars")

# graphically explore the data set
cars |> Voyager

# filter and save the data set
cars |>
    @filter(_.Origin == "USA") |>
    save("/home/alec/code/homework/julia/Queryverse/us_cars.csv")

# load that dataset back
load("/home/alec/code/homework/julia/Queryverse/us_cars.csv") |>
    @vlplot(:point, x=:Miles_per_Gallon, y=:Weight_in_lbs, color="Cylinders:n")

## File IO

# load(filename, [args]; [kwargs])

cars = load("/home/alec/code/homework/julia/Queryverse/us_cars.csv")

# save(filename, table, [args]; [kwargs])
# table |> save(filenme, [args]; [kwargs])

## What is a table?

# Defined by TableTraits.jl & IterableTables.jl
# Iterate over named tuples

load("/home/alec/code/homework/julia/Queryverse/us_cars.csv") |> DataFrame
load("/home/alec/code/homework/julia/Queryverse/us_cars.csv") |> table

## Piping

# source |> step1 |> step2
# source |> @tee(step1) |> step2

## Querying

dataset("cars") |>
    @filter _.Origin == "Europe"

# can query an iterator
1:8 |> @filter(_%2==0) |> @orderby_descending(_)
1:8 |> @filter(_%2==0) |> @orderby_descending(_) |> collect

# when querying dictionaries, _ refers the (key, value) tuple
x = Dict(:a=>4, :b=>2, :c=>8) |> @filter(_[2] > 3)
x = Dict(:a=>4, :b=>2, :c=>8) |> @filter(_[2] > 3) |> collect
x = Dict(:a=>4, :b=>2, :c=>8) |> @filter(_[2] > 3) |> Dict

# within any query operator
# _ is syntactic surgar for creating anonymous functions
# _ => _ -> _
# log(_) => _ -> log(_)
# _.foo==3 => _ -> _.foo==3


# @filter
# filters out elements based on a logical expression
1:10 |> @filter(i -> i > 5)
1:10 |> @filter(_ > 5)

# @map
# applies a function to all elements
1:10 |> @map(_^2)
1:10 |> @map(_ => _^2) |> Dict
cars |> @map(_.Origin)

# special syntax for creating named tuples inside of query operators
# {fieldname1=value1, fieldname2=value2, fieldname3=value3, ...}
# {fieldname=value1, value2, fieldname3=value3, ...} # use default variable name for variable #2
1:10 |> @map({foo=_, bar=_^2})
cars |> @map({_.Name, _.Year}) |> table
# cars |> @map(_.Name => Date(_.Year)) |> Dict

#@take & @drop
1:10 |> @drop(3) # drops the first three values
1:10 |> @take(3) # takes the first three values

# sorting
cars |> @orderby(_.Origin) |> @thenby(_.Year)

# grouping

# _ refers to a group here
cars |> @groupby(_.Origin) |> @map(length(_))
cars |> @groupby(_.Origin) |> @map(_[3])
cars |> @groupby(_.Origin) |> @map({Origin=_.Origin[1], Count=length(_)})
