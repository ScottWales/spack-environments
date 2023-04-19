#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

LFRICSRC=/scratch/hc46/saw562/tmp/lfric/

module purge

source bin/activate.sh lfric_v0

module load intel-compiler/2021.8.0

module load python3-as-python
module use /g/data/access/modules
module load psyclone/2.3.1
module load rose-picker/2.0
module load jinja2/3.0.1

module list

export FPP="cpp -traditional-cpp"
export LDMPI=mpif90
export PSYCLONE_TRANSFORMATION=nci-gadi

# make -C $LFRICSRC clean
# make -C $LFRICSRC/miniapps/gungho_model/ -j 4

cd $LFRICSRC/miniapps/gungho_model_bare/example
#mpirun -n 6 ../bin/gungho_model configuration.nml

ldd ../bin/gungho_model > libs

