#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Links libraries in the Mamba environment with those in the Spack environment

CONDA_PREFIX=$MAMBA_ROOT/envs/container
SPACK_ENV_VIEW=$SPACK_ROOT/var/spack/environments/container/.spack-env/view

for LIB in $CONDA_PREFIX/lib/*; do
    # Resolve library version libfoo.so -> libfoo.so.1.2
    REAL_LIB=$(readlink -f $LIB)

    # Spack versions of both libfoo.so and libfoo.so.1.2
    SPACK_LIB=$SPACK_ENV_VIEW/lib/$(basename $LIB)
    SPACK_REAL_LIB=$SPACK_ENV_VIEW/lib/$(basename $REAL_LIB)

    # Special cases
    if [[ $(basename $REAL_LIB) =~ libhdf5hl_fortran.so.* ]]; then
        ver=$(basename $REAL_LIB)
        SPACK_REAL_LIB=$SPACK_ENV_VIEW/lib/libhdf5_hl_fortran.${ver#*.}
    elif [[ $(basename $REAL_LIB) == "libopenblasp-r0.3.23.so" ]]; then
        SPACK_REAL_LIB=$SPACK_ENV_VIEW/lib/libopenblas_haswell-r0.3.23.so
    elif [[ $(basename $REAL_LIB) == "libopenblasp-r0.3.23.a" ]]; then
        SPACK_REAL_LIB=$SPACK_ENV_VIEW/lib/libopenblas_haswell-r0.3.23.a
    elif [[ $(basename $LIB) =~ libgslcblas.so.* ]]; then
        SPACK_REAL_LIB=$SPACK_ENV_VIEW/lib/libgslcblas.so.0.0.0
    fi

    if [ -f $SPACK_REAL_LIB ]; then
        # Replace libfoo.so in mamba with libfoo.so.1.2 in spack
        ln -sfv $SPACK_REAL_LIB $LIB

    elif [ -f $SPACK_LIB ]; then
        echo "ERROR: Mamba/Spack library version mismatch"
        echo "  mamba: $(basename $REAL_LIB)"
        echo "  spack: $(basename $(readlink -f $SPACK_LIB))"
        echo
        echo "  mamba: $LIB"
        echo "  real:  $REAL_LIB"
        echo
        echo "  spack: $SPACK_LIB"
        echo "  real:  $(readlink -f $SPACK_LIB)"
        exit 1
    fi
done
