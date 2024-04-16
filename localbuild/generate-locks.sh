#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

if [ -f /build/mamba.yaml ]; then
    $MAMBA_ROOT/bin/conda-lock --mamba \
        --platform linux-64 \
        --file /build/mamba.yaml \
        --lockfile /build/mamba.lock \
        -c conda-forge \
        -c "$MAMBA_REPO"
fi

source /opt/spack/share/spack/setup-env.sh

# Dummy compiler for solver
cat >> $SPACK_ROOT/etc/spack/compilers.yaml <<EOF
- compiler:
    paths:
      cc: /dev/null
      cxx: /dev/null
      f77: /dev/null
      fc: /dev/null
    spec: intel@2021.9.0
    operating_system: rocky8
    target: x86_64
    modules: []
    environment: {}
EOF

spack arch

# Setup bootstrapping for air gapped compute nodes
if ! [ -d $SPACK_CACHE/bootstrap ]; then
    spack bootstrap mirror --binary-packages $SPACK_ROOT/bootstrap
fi
spack bootstrap add --trust local-sources $SPACK_ROOT/bootstrap/metadata/sources
spack bootstrap add --trust local-binaries $SPACK_ROOT/bootstrap/metadata/binaries

spack bootstrap disable github-actions-v0.5
spack bootstrap disable github-actions-v0.4

spack bootstrap list

ls /build

env=$SPACKENVS/envs/$BASE_ENV/spack.yaml
variant=$SPACKENVS/envs/$BASE_ENV/variants/$VARIANT.yaml

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
spack mirror create --directory $SPACK_CACHE --all

spack find
