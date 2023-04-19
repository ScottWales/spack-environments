#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

INSTALL_ROOT=$PWD

# Install an environment at NCI
ENV=$1
ENVPATH=/scratch/$PROJECT/$USER/ngm/envs/$ENV

# Activate spack
export SPACK_SYSTEM_CONFIG_PATH=$INSTALL_ROOT/config/gadi
#source /g/data/access/spack/0.19.0/share/spack/setup-env.sh
source /home/562/saw562/projects/spack-pipeline/spack/share/spack/setup-env.sh

# Create the environment
spack env create --without-view $ENV envs/$ENV/spack.yaml
spack env activate $ENV

# Add local repos
spack repo add $INSTALL_ROOT/repos/jopa
spack repo add $INSTALL_ROOT/repos/bom-ngm

# Setup Mamba
# if [ -f envs/$ENV/mamba.yaml ]; then
#     if ! [ -d $ENVPATH/mamba/conda-meta ]; then
#         mamba env create -p $ENVPATH/mamba -f envs/$ENV/mamba.yaml
#     fi
# 
#     CONFIG=$(mktemp)
# 
#     cat > $CONFIG <<EOF
# packages:
#     python:
#         externals:
#             - spec: python@3
#               prefix: "$ENVPATH/mamba"
# EOF
#     spack config add --file $CONFIG
# 
#     rm $CONFIG
# fi

# Concretize and install
spack concretize
spack install
spack env loads --dependencies > /dev/null
