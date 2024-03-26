#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

function e() {
    # Debug commands
    echo "$@"
    "$@"
}

# Where to write container fragments
OUTDIR=/scratch/$PROJECT/$USER/tmp
SQUASHFS_ROOT="$TMPDIR/squashfs"

export SPACKENVS=~/projects/jopa-spack
export ENV=lfric-v0
export VARIANT=intel-openmpi

export SPACK_ALLOW_BUILDS=true

# Locally built packages
export MAMBA_REPO=/scratch/hc46/hc46_gitlab/conda-bld/
export SPACK_CACHE=/scratch/$PROJECT/$USER/tmp/spack-build

export SPACK_VERSION=0.21.2
export SPACK_ROOT=/opt/spack
export SPACK_DISABLE_LOCAL_CONFIG=true
export SPACK_USER_CACHE_PATH=/tmp/spack

export MAMBA_ROOT=/opt/mamba
export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

export APPDIR="$OUTDIR/${ENV}-${VARIANT}"

# Squashfs paths to mount in the container while building
SQUASHFS_DIRS="/build /opt/spack /opt/mamba"

MOUNT_ARGS=""

for d in $SQUASHFS_DIRS; do
    mkdir -p $SQUASHFS_ROOT$d
    MOUNT_ARGS="$MOUNT_ARGS --bind $SQUASHFS_ROOT$d:$d:rw"
done
