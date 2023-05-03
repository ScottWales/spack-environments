#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

: ${SPACK_ENV_VIEW:=$SPACK_ENV/.spack-env/view}

export FCM_KEYWORDS=${FCM_KEYWORDS:-$SPACK_ENV_VIEW/etc/fcm/default-keyword.cfg}
export LDMPI=mpifort
export FPP="cpp -traditional"
export FFLAGS="${FFLAGS:-} -I${SPACK_ENV_VIEW}/include -I${MPI_PATH}/lib"
export PFUNIT=$SPACK_ENV_VIEW

