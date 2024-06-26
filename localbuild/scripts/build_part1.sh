#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales
#PBS -l wd
#PBS -q copyq
#PBS -l ncpus=1
#PBS -l mem=4gb
#PBS -l walltime=1:00:00
#PBS -l jobfs=20gb
#PBS -l storage=gdata/access
#PBS -j oe

set -eu
set -o pipefail

# Common variables to both stages
source $SCRIPT_DIR/scripts/env.sh

if [ -f "$NGM_OUTDIR/part1.tar" ]; then
    rm "$NGM_OUTDIR/part1.tar"
fi

mkdir -p "$SQUASHFS_ROOT"

e $APPTAINER exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/base/install-mamba.sh
e $APPTAINER exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/base/install-spack.sh

cp $SPACKENVS/containers/base/entrypoint.sh $SQUASHFS_ROOT/build
cp -r $SPACKENVS/repos/bom-ngm/packages $SQUASHFS_ROOT/$SPACK_ROOT/var/spack/repos/bom-ngm
cp -r $SPACKENVS/envs/$BASE_ENV/* $SQUASHFS_ROOT/build
chmod +x $SQUASHFS_ROOT/build/*.sh

e $APPTAINER exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SCRIPT_DIR/scripts/generate-locks.sh

e $APPTAINER exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/spack-env/install-mamba-env.sh

# Save the build directories for part 2
tar -C "$SQUASHFS_ROOT" -cf "$NGM_OUTDIR/part1.tar" build opt
