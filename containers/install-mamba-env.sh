#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

[ -f /build/mamba.yaml ] && $MAMBA_ROOT/bin/mamba env update -n container -f /build/mamba.yaml
