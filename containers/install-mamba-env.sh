#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

if [ -f /build/mamba.yaml ]; then
    $MAMBA_ROOT/bin/mamba env update -n container -f /build/mamba.yaml
fi
