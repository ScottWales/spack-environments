#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

if [ -f $SPACKENVS/envs/$ENV/mamba.yaml ]; then
    $MAMBA_ROOT/bin/conda-lock --mamba \
        --platform linux-64 \
        --file $SPACKENVS/envs/$ENV/mamba.yaml \
        --lockfile /build/mamba.lock \
        -c conda-forge \
        -c "$MAMBA_REPO"
fi

source /opt/spack/share/spack/setup-env.sh

env=$SPACKENVS/envs/$ENV/spack.yaml
variant=$SPACKENVS/envs/$ENV/variants/$VARIANT.yaml

cp $env /build/spack.yaml
spack env activate --without-view /build
spack config add --file $SPACKENVS/ci/spack-mamba-match.yaml
if [ -f $variant ]; then
    spack config add --file $variant
fi
if [[ "$VARIANT" =~ intel-* ]]; then
    spack add intel-oneapi-compilers-classic@2021.9.0
fi

spack config get packages

# Concretize the specs
spack concretize --force --fresh

# Fetch package sources
spack fetch
