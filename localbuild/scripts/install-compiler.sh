#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

source /opt/spack/share/spack/setup-env.sh

spack bootstrap list

# Install the actual compiler
spack install --no-check-signature intel-oneapi-compilers-classic@2021.9.0

spack compiler remove intel
spack compiler find $(spack find --format '{prefix}' intel-oneapi-compilers-classic)
spack compilers

spack buildcache push --unsigned ci-mirror $(spack find --format '/{hash}')
