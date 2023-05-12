#!/bin/bash

export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Load Spack and Mamba
source $SPACK_ROOT/share/spack/setup-env.sh
source $MAMBA_ROOT/etc/profile.d/conda.sh
source $MAMBA_ROOT/etc/profile.d/mamba.sh

# Load Mamba environment
mamba activate container
spack env activate container

# Load Spack environment if installed
if [ -f $SPACK_ROOT/bin/activate.sh ]; then
    source $SPACK_ROOT/bin/activate.sh
fi

# Add any definitions from the environment
if [ -f /build/env.activate.sh ]; then
    source /build/env.activate.sh
fi

eval "$@"
