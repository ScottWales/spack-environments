#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

function e() {
    # Debug commands
    echo "$@"
    "$@"
}

# Where to write container fragments
OUTDIR=/scratch/$PROJECT/$USER/tmp

# Where to build the squashfs paths
SQUASHFS_ROOT="$TMPDIR/squashfs"

# Path to the container repo
export SPACKENVS="$SCRIPT_DIR/.."

# Locally built packages
export MAMBA_REPO=/scratch/hc46/hc46_gitlab/conda-bld/
export SPACK_CACHE=/scratch/$PROJECT/$USER/tmp/spack-build

# Spack settings
export SPACK_VERSION=0.21.2
export SPACK_DISABLE_LOCAL_CONFIG=true
export SPACK_USER_CACHE_PATH=/tmp/spack
export SPACK_ALLOW_BUILDS=true

# Path to Spack install
export SPACK_ROOT=/opt/spack

# Path to Conda install
export MAMBA_ROOT=/opt/mamba

# Python that spack should use
export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Base container image
export BASEIMAGE=~saw562/projects/gadicontainer/baseimage.sif

# Install directory
export APPDIR="$OUTDIR/${BASE_ENV}-${VARIANT}"

# Squashfs paths to mount in the container while building
SQUASHFS_DIRS="/build /opt/spack /opt/mamba"

MOUNT_ARGS=""

for d in $SQUASHFS_DIRS; do
    mkdir -p $SQUASHFS_ROOT$d
    MOUNT_ARGS="$MOUNT_ARGS --bind $SQUASHFS_ROOT$d:$d:rw"
done
