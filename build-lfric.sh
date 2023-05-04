#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

#PBS -l ncpus=16
#PBS -l mem=64gb
#PBS -l walltime=1:00:00
#PBS -l jobfs=10gb
#PBS -l wd
#PBS -l storage=gdata/access+scratch/hc46+gdata/ki32


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
export FFLAGS="-gen-interfaces"
export LDMPI=mpif90
export PSYCLONE_TRANSFORMATION=nci-gadi

export FCM_KEYWORDS=/g/data/access/apps/fcm/2019.09.0/etc/fcm/keyword.cfg

APP=gravity_wave

echo $CPATH | sed 's/:/\n/g'

#make -C $LFRICSRC/lfric_atm clean
make -C $LFRICSRC/lfric_atm/ -j ${PBS_NCPUS:-4} > build.log

#cd $LFRICSRC/miniapps/$APP/example
#../bin/$APP configuration.nml

#ldd ../bin/gungho_model > libs

