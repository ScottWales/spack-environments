#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales
#PBS -l wd
#PBS -l ncpus=16
#PBS -l mem=64gb
#PBS -l walltime=1:00:00
#PBS -l jobfs=20gb
#PBS -l storage=gdata/access
#PBS -m ae
#PBS -j oe

set -eu
set -o pipefail

# Common variables to both stages
source $SCRIPT_DIR/scripts/env.sh

# Load the build directories from part 1
mkdir -p $SQUASHFS_ROOT
tar -C $SQUASHFS_ROOT -xf "$NGM_OUTDIR/part1.tar"

export SPACK_JOBS=${PBS_NCPUS:-2}

# Make sure python is available
export SINGULARITYENV_PREPEND_PATH=$MAMBA_ROOT/envs/container/bin

cp $SCRIPT_DIR/scripts/Makefile $SQUASHFS_ROOT/build/Makefile

e $APPTAINER exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SCRIPT_DIR/scripts/install-compiler.sh

# Regenerate locks for current target
e $APPTAINER exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SCRIPT_DIR/scripts/generate-locks-part2.sh
e $APPTAINER exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/spack-env/install-spack-env.sh

# Squashfs the image
mksquashfs $SQUASHFS_ROOT $NGM_OUTDIR/spack.squashfs -all-root -noappend -processors ${PBS_NCPUS:-1}

# Set up APPDIR and add in squashfs to this container
if [ -d "$APPDIR" ]; then
    rm -r "$APPDIR"
fi
mkdir -p "$APPDIR"/{bin,etc}
cp "$BASEIMAGE" "$APPDIR/etc/image.sif"
$APPTAINER sif add \
    --datatype 4 \
    --partfs 1 \
    --parttype 4 \
    --partarch 2 \
    --groupid 1 \
    "$APPDIR/etc/image.sif" \
    "$NGM_OUTDIR/spack.squashfs"

if [[ -d /opt/nci ]]; then
	cp $SPACKENVS/etc/imagerun-gadi "$APPDIR/etc/imagerun"
else
	cp $SPACKENVS/etc/imagerun-generic "$APPDIR/etc/imagerun"
fi
cp $SPACKENVS/etc/run-image-command.sh "$APPDIR/bin"
cp $SPACKENVS/etc/rose "$APPDIR/bin"

ln -s "../etc/imagerun" "$APPDIR/bin/imagerun"

COMMANDS="$($APPDIR/bin/imagerun "/build/exportcommands.sh" || true) orted"
echo "COMMANDS=$COMMANDS"

for f in $COMMANDS; do
    ln -sf "run-image-command.sh" "$APPDIR/bin/$(basename $f)"
done

cat <<EOF
Container executables available at

    $APPDIR/bin

Add to PATH
EOF
