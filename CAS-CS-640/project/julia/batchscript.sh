#!/bin/bash -l

#$ -P cs640grp
#$ -l h_rt=12:00:00
#$ -N cs640project
#$ -o log
#$ -e err
#$ -pe omp 4
#$ -l gpus=0.25
#$ -l gpu_c=3.5

module load cuda
module load julia

julia run.jl
