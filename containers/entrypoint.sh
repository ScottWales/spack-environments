#!/bin/bash

if [ -z "${SPACK_DONT_ISOLATE:-}" ]; then
    # Don't consider the user's ~/.spack directory
    export SPACK_DISABLE_LOCAL_CONFIG=1
fi

if [ -z "${PYTHON_DONT_ISOLATE:-}" ]; then
    # Don't consider the user's ~/.local directory
    export PYTHONNOUSERSITE=1
    export PYTHONPATH=""
fi

export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Load Spack and Mamba
source $SPACK_ROOT/share/spack/setup-env.sh
source $MAMBA_ROOT/etc/profile.d/conda.sh
source $MAMBA_ROOT/etc/profile.d/mamba.sh

# Load Mamba environment
mamba activate container

# Load Spack environment if installed
if [ -f $SPACK_ROOT/bin/activate.sh ]; then
    source $SPACK_ROOT/bin/activate.sh
fi

# Add any definitions from the environment
if [ -f /build/env.activate.sh ]; then
    source /build/env.activate.sh
fi

eval "$@"
