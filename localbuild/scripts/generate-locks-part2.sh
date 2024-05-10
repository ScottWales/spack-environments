#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

source /opt/spack/share/spack/setup-env.sh

env=$SPACKENVS/envs/$BASE_ENV/spack.yaml
variant=$SPACKENVS/envs/$BASE_ENV/variants/$VARIANT.yaml

spack arch

rm /build/spack.lock

# Activate the environment
spack env activate --without-view /build

# Concretize the specs
spack concretize --force --fresh
