#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

# Bootstraps the environments in this repository into your Spack environment
spack repo add repos/jopa

for envfile in envs/*.yaml; do
    spack env create $(basename $envfile .yaml) $envfile
done
