#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Install an environment at NCI
ENV=$1

# Activate spack
export SPACK_SYSTEM_CONFIG_PATH=$SCRIPT_DIR/../config/gadi
source ~saw562/spack-base/share/spack/setup-env.sh

# TODO: Get this path from `spack config get config`
INSTALL_TREE_ROOT=/scratch/$PROJECT/$USER/spack

# Nemo envs don't compile nemo itself, so still need a compiler
module use /g/data/access/projects/access/modules
module load intel-compiler/2021.8.0

# This is required by the 'loads' script
module use $INSTALL_TREE_ROOT/modules/linux-rocky8-*

source $INSTALL_TREE_ROOT/envs/$ENV/activate.sh
