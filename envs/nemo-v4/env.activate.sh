#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

: ${SPACK_ENV_VIEW:=$SPACK_ENV/.spack-env/view}

export FCM_KEYWORDS=${FCM_KEYWORDS:-/build/fcm-keyword.cfg}

export xios_path=${SPACK_ENV_VIEW}
export XIOS_PATH=${SPACK_ENV_VIEW}
# export prism_path=${SPACK_ENV_VIEW}
# export PRISM_PATH=${SPACK_ENV_VIEW}

export XIOS_INC=${xios_path}/include
export XIOS_LIB=${xios_path}/lib
export XIOS_EXEC=${xios_path}/bin/xios_server.exe
# export OASIS_INC=${prism_path}/include
# export OASIS_LIB=${prism_path}/lib
