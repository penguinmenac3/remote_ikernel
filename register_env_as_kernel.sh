#!/bin/bash

if ! [ -z "$1" ]
then
    CONDA_ENV=$1
    remote_ikernel manage --add \
        --name "$CONDA_ENV (No GPU)" \
        --interface "slurm" --cpus 8 \
        --remote-launch-args "-p batch --job-name='debug' --mem=64G --ntasks=1 --gpus-per-task=0 --time=08:00:00" \
        --kernel_cmd "source /netscratch/$USER/.miniconda3/etc/profile.d/conda.sh && conda activate $CONDA_ENV && ipython kernel -f {host_connection_file} {host_connection_file}"

    remote_ikernel manage --add \
        --name "$CONDA_ENV" \
        --interface "slurm" --cpus 8 \
        --remote-launch-args "-p batch --job-name='debug' --mem=64G --ntasks=1 --gpus-per-task=1 --time=01:00:00" \
        --kernel_cmd "source /netscratch/$USER/.miniconda3/etc/profile.d/conda.sh && conda activate $CONDA_ENV && ipython kernel -f {host_connection_file} {host_connection_file}"
else
    echo "Usage: bash register_env_as_kernel.sh <conda_env_name>"
fi
