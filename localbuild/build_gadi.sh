#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Container to build
export BASE_ENV=lfric-v0
export VARIANT=intel-openmpi

# Base container image
export BASEIMAGE=/g/data/access/ngm/data/gadicontainer/v1/baseimage.sif

# Where to write container fragments
export NGM_OUTDIR=/scratch/$PROJECT/$USER/tmp

# Locally built packages
export MAMBA_REPO=/scratch/hc46/hc46_gitlab/conda-bld/
export SPACK_CACHE=/scratch/$PROJECT/$USER/tmp/spack-build

export APPTAINER=/opt/singularity/bin/singularity

# Queue to run the build on
export QUEUE=normal

PBS_FLAGS="-v PROJECT,SCRIPT_DIR,BASE_ENV,VARIANT,BASEIMAGE,NGM_OUTDIR,MAMBA_REPO,SPACK_CACHE,APPTAINER"

# Run tasks requiring network
PART1=$(qsub $PBS_FLAGS "$SCRIPT_DIR/scripts/build_part1.sh")

# Run main spack build
PART2=$(qsub -q $QUEUE -W depend=afterok:${PART1} $PBS_FLAGS "$SCRIPT_DIR/scripts/build_part2.sh")

source env.sh
cat <<EOF
PBS tasks ${PART1} ${PART2}

Container commands will be available under

    $APPDIR/bin

when the build completes
EOF
