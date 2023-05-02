#!/bin/bash

export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Load Spack
source $SPACK_ROOT/share/spack/setup-env.sh
source $MAMBA_ROOT/etc/profile.d/conda.sh
source $MAMBA_ROOT/etc/profile.d/mamba.sh

# Load environment
mamba activate container
spack env activate container

eval "$@"
