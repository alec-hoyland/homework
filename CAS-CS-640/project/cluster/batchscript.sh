#!/bin/bash -l

#$ -P cs640grp
#$ -l h_rt=72:00:00
#$ -N cs640project
#$ -o log1
#$ -e err1
## $ -pe omp 8
#$ -t 1-8

module load julia

julia run_$SGE_TASK_ID.jl
