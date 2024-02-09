#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

mkdir -p artifacts

for env in envs/metplus-v5/spack.yaml; do
    ENV=$(basename $(dirname $env))
    echo "ENV=$ENV"
    if [ -f envs/$ENV/mamba.yaml ]; then
        mkdir -p artifacts/$ENV
        $MAMBA_ROOT/bin/conda-lock --mamba \
            --platform linux-64 \
            --file envs/$ENV/mamba.yaml \
            --lockfile artifacts/$ENV/mamba.lock \
            --virtual-package-spec ci/virtual-packages.yml \
            -c conda-forge \
            -c "$MAMBA_REPO"
    fi
done
