#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

if [ -f /build/mamba.lock ]; then
    $MAMBA_ROOT/bin/mamba env remove -n container
    $MAMBA_ROOT/bin/conda-lock install -n container --lockfile /build/mamba.lock 
    $MAMBA_ROOT/bin/mamba clean --all
fi
