#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

: ${SPACK_ENV_VIEW:=$SPACK_ENV/.spack-env/view}

export PATH=$SPACK_ENV_VIEW/METplus/ush:$PATH
