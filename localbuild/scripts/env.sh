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

# Where to build the squashfs paths
: ${SQUASHFS_ROOT:="${TMPDIR}/squashfs"}
export SQUASHFS_ROOT

# Path to the container repo
export SPACKENVS="$SCRIPT_DIR/.."

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

# Install directory
export APPDIR="$NGM_OUTDIR/${BASE_ENV}-${VARIANT}"

# Squashfs paths to mount in the container while building
SQUASHFS_DIRS="/build /opt/spack /opt/mamba"

MOUNT_ARGS=""

for d in $SQUASHFS_DIRS; do
    mkdir -p $SQUASHFS_ROOT$d
    MOUNT_ARGS="$MOUNT_ARGS --bind $SQUASHFS_ROOT$d:$d:rw"
done

