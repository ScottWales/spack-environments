#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales
#PBS -l wd
#PBS -l ncpus=8
#PBS -l mem=32gb
#PBS -l jobfs=100gb
#PBS -l walltime=1:00:00

set -eu
set -o pipefail

INSTALL_ROOT=$PWD

# Install an environment at NCI
ENV=$1

export SPACK_COMPILER=intel@2021.8.0
export SPACK_MPI="openmpi@4.1.4 ~static"

# Activate spack
export SPACK_SYSTEM_CONFIG_PATH=$INSTALL_ROOT/config/gadi
#source /g/data/access/spack/0.19.0/share/spack/setup-env.sh
source /home/562/saw562/projects/spack-pipeline/spack/share/spack/setup-env.sh

export SPACK_JOBS=${PBS_NCPUS:-4}

bin/install.sh $ENV
