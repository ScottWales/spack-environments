#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales
#PBS -l wd
#PBS -q copyq
#PBS -l ncpus=1
#PBS -l mem=4gb
#PBS -l walltime=1:00:00
#PBS -l jobfs=20gb
#PBS -l storage=scratch/hc46+gdata/access
#PBS -j oe

set -eu
set -o pipefail

module load singularity

# Common variables to both stages
source env.sh

if [ -f "$OUTDIR/part1.tar" ]; then
    rm "$OUTDIR/part1.tar"
fi

mkdir -p "$SQUASHFS_ROOT"

e singularity exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/base/install-mamba.sh
e singularity exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/base/install-spack.sh

cp $SPACKENVS/containers/base/entrypoint.sh $SQUASHFS_ROOT/build
cp -r $SPACKENVS/repos/bom-ngm/packages $SQUASHFS_ROOT/$SPACK_ROOT/var/spack/repos/bom-ngm
cp -r $SPACKENVS/envs/$BASE_ENV/* $SQUASHFS_ROOT/build
chmod +x $SQUASHFS_ROOT/build/*.sh

# e singularity exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash install-compiler.sh
e singularity exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash generate-locks.sh

e singularity exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/spack-env/install-mamba-env.sh

# Save the build directories for part 2
tar -C "$SQUASHFS_ROOT" -cf "$OUTDIR/part1.tar" build opt
