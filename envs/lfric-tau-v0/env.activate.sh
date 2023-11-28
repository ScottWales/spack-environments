#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

: ${SPACK_ENV_VIEW:=$SPACK_ENV/.spack-env/view}

export FCM_KEYWORDS=${FCM_KEYWORDS:-/build/fcm-keyword.cfg}
export LDMPI=tau_f90.sh
export FPP="cpp -traditional"
export FFLAGS="${FFLAGS:-} -I$SPACK_ENV_VIEW/include -I$SPACK_ENV_VIEW/lib"
export PFUNIT=$SPACK_ENV_VIEW
export PSYCLONE_CONFIG=${PSYCLONE_CONFIG:-/build/psyclone.cfg}

spack load tau
export TAU_OPTIONS="-optKeepFiles -optCompInst -optMemDbg"
export TAU_TRACK_MEMORY_LEAKS=1 
export TAU_TRACK_IO_PARAMS=1
# export TAU_TRACK_HEAP=1