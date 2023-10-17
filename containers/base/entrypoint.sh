#!/bin/bash

if [ -n "${NGMENV_DEBUG:-}" ]; then
function debug() {
    echo "$@"
}
else
function debug() {
    :
}
fi

# Set default locale
if [ -z "${LC_ALL:-}" ]; then
    export LC_ALL="C"
fi

if [ -z "${NGMENV_SPACK_DONT_ISOLATE:-}" ]; then
    # Don't consider the user's ~/.spack directory
    debug  spack is isolated
    export SPACK_DISABLE_LOCAL_CONFIG=1
    export SPACK_USER_CACHE_PATH=${TMPDIR:-/tmp}/spack-cache
else
    debug  spack is not isolated
fi

if [ -z "${NGMENV_PYTHON_DONT_ISOLATE:-}" ]; then
    # Don't consider the user's ~/.local directory
    debug  python is isolated
    export PYTHONNOUSERSITE=1
    export PYTHONPATH=""
else
    debug  python is not isolated
fi

export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Load Spack and Mamba
debug  load spack
source $SPACK_ROOT/share/spack/setup-env.sh
debug  load conda
source $MAMBA_ROOT/etc/profile.d/conda.sh
debug  load mamba
source $MAMBA_ROOT/etc/profile.d/mamba.sh

# Load Mamba environment
debug  activate mamba
mamba activate container

# Load Spack environment if installed
if [ -f $SPACK_ROOT/bin/activate.sh ]; then
    debug  activate spack
    source $SPACK_ROOT/bin/activate.sh
fi

# Add any definitions from the environment
if [ -f /build/env.activate.sh ]; then
    debug  extra env
    source /build/env.activate.sh
fi

# Allow things like '()' in arguments
function token_quote {
  local quoted=()
  for token; do
    quoted+=( "$(printf '%q' "$token")" )
  done
  printf '%s\n' "${quoted[*]}"
}

eval $(token_quote "$@")
