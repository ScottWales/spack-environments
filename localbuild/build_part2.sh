#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales
#PBS -l wd
#PBS -q normal
#PBS -l ncpus=16
#PBS -l mem=64gb
#PBS -l walltime=1:00:00
#PBS -l jobfs=20gb
#PBS -j oe

set -eu
set -o pipefail

# Compiles the Spack packages
module load singularity

# Common variables to both stages
source env.sh

# Load the build directories from part 1
mkdir -p $SQUASHFS_ROOT
tar -C $SQUASHFS_ROOT -xf "$OUTDIR/part1.tar"

export SPACK_JOBS=${PBS_NCPUS:-2}

e singularity exec $MOUNT_ARGS "$BASEIMAGE" /bin/bash $SPACKENVS/containers/spack-env/install-spack-env.sh

# Squashfs the image
mksquashfs $SQUASHFS_ROOT $OUTDIR/spack.squashfs -all-root -noappend

# Set up APPDIR and add in squashfs to this container
if [ -d "$APPDIR" ]; then
    rm -r "$APPDIR"
fi
mkdir -p "$APPDIR"/{bin,etc}
cp "$BASEIMAGE" "$APPDIR/etc/image.sif"
/opt/singularity/bin/singularity sif add \
    --datatype 4 \
    --partfs 1 \
    --parttype 4 \
    --partarch 2 \
    --groupid 1 \
    "$APPDIR/etc/image.sif" \
    "$OUTDIR/spack.squashfs"

cp $SPACKENVS/etc/imagerun-gadi "$APPDIR/etc/imagerun"
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
