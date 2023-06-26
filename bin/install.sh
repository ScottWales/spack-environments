#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

ENV=$1

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )
INSTALL_ROOT=$SCRIPT_DIR/..

spack clean -m

# Create the environment
if ! $(spack env list | grep -w $ENV > /dev/null); then
    spack env create --without-view $ENV envs/$ENV/spack.yaml
    spack env activate $ENV

    # Add local repos
    spack repo add $INSTALL_ROOT/repos/jopa
    spack repo add $INSTALL_ROOT/repos/bom-ngm
else
    spack env activate $ENV
fi

if [ -n "${SPACK_COMPILER:-}" ]; then
    spack config add "packages:all:require:'%$SPACK_COMPILER'"
fi

if [ -n "${SPACK_MPI:-}" ]; then
    spack config add "packages:mpi:require:'$SPACK_MPI'"
fi

# Setup Mamba
#if [ -f envs/$ENV/mamba.yaml ]; then
#    if ! [ -d $SPACK_ENV/mamba ]; then
#        mamba env create -p $SPACK_ENV/mamba -f envs/$ENV/mamba.yaml
#    else
#        mamba env update -p $SPACK_ENV/mamba -f envs/$ENV/mamba.yaml
#    fi
#
#    PYTHON_VERSION=$($SPACK_ENV/mamba/bin/python3 --version | cut -d ' ' -f 2)
#
#    CONFIG=$(mktemp)
#
#    cat > $CONFIG <<EOF
#packages:
#    python:
#        externals:
#            - spec: python@${PYTHON_VERSION}.mamba
#              prefix: "$SPACK_ENV/mamba"
#        buildable: False
#        require: 'python@${PYTHON_VERSION}.mamba'
#EOF
#    spack config add --file $CONFIG
#
#    rm $CONFIG
#fi

echo $SPACK_ENV

# Concretize and install
spack concretize --force --fresh
spack install ${SPACK_JOBS:+--jobs=$SPACK_JOBS}

spack module tcl refresh -y
spack env loads > /dev/null

cat > $SPACK_ENV/activate.sh << EOF
spack env activate $ENV
source $SPACK_ENV/loads
EOF

if [ -f envs/$ENV/env.activate.sh ]; then
    cat envs/$ENV/env.activate.sh >> $SPACK_ENV/activate.sh
fi
