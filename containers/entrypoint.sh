#!/bin/bash

export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Load Spack and Mamba
source $SPACK_ROOT/share/spack/setup-env.sh
source $MAMBA_ROOT/etc/profile.d/conda.sh
source $MAMBA_ROOT/etc/profile.d/mamba.sh

# Load Mamba environment
mamba activate container

# Load Spack environment if installed
if [ -f /build/spack.activate.sh ]; then
    source /build/spack.activate.sh
fi

eval "$@"
