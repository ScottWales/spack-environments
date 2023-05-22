#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

cd $MAMBA_ROOT
curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash Mambaforge-Linux-x86_64.sh -b -f -p $MAMBA_ROOT
$MAMBA_ROOT/bin/mamba install conda-lock
$MAMBA_ROOT/bin/mamba create -n container python pyyaml
$MAMBA_ROOT/bin/mamba clean --all
$MAMBA_ROOT/bin/conda config --system --append channels "$MAMBA_REPO"
rm Mambaforge-Linux-x86_64.sh

