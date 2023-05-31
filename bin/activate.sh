#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Install an environment at NCI
ENV=$1
ENVPATH=/scratch/$PROJECT/$USER/ngm/envs/$ENV

# Activate spack
export SPACK_SYSTEM_CONFIG_PATH=$SCRIPT_DIR/../config/gadi

#source /g/data/access/spack/0.19.0/share/spack/setup-env.sh
source /home/562/saw562/projects/spack-pipeline/spack/share/spack/setup-env.sh

spack env activate $ENV

source $SPACK_ENV/loads

