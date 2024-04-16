#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

if [ -f /build/mamba.lock ]; then
    $MAMBA_ROOT/bin/mamba env remove -n container

    # Needs a specific file name for conda-lock
    ln -s /build/mamba.lock $MAMBA_ROOT/conda-lock.yml
    $MAMBA_ROOT/bin/conda-lock install --prefix $MAMBA_ROOT/envs/container $MAMBA_ROOT/conda-lock.yml

    $MAMBA_ROOT/bin/mamba clean --all --yes
fi
