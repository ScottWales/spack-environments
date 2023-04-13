#!/bin/bash

# Load Spack
source $SPACK_ROOT/share/spack/setup-env.sh

# Load environment
spack env activate $CONTAINER_ENV

eval "$@"
