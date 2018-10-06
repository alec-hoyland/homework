## Julia for Data Science

# download the data
cd("/home/alec/code/homework/julia/")
P = download("https://raw.githubusercontent.com/nassarhuda/easy_data/master/programming_languages.csv", "programming_languages.csv")

# read the data
using CSV
P, H = CSV.File("programming_languages.csv", header=true)
