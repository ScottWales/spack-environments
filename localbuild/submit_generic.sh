#!/bin/bash

# Build the container on a generic system
# Requires:
#     conda (e.g. from miniforge)

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Container to build
export BASE_ENV=lfric-v0
export VARIANT=intel-openmpi
export QUEUE=normal

# Where to write container fragments
export NGM_OUTDIR=$HOME/ngm

export SQUASHFS_ROOT=${NGM_OUTDIR}/squashfs

# Locally built packages
export MAMBA_REPO=$NGM_OUTDIR/cache/mamba
export SPACK_CACHE=$NGM_OUTDIR/cache/spack

export TMPDIR=${NGM_OUTDIR}/tmp
mkdir -p "$TMPDIR"

source $CONDA_PREFIX/etc/profile.d/conda.sh
mkdir -p "$NGM_OUTDIR"

# 1. Install Apptainer if not available
if ! which apptainer &> /dev/null; then
	if ! conda env list | grep -w '^apptainer' &> /dev/null; then
		echo "Installing apptainer"
		conda create -n apptainer -c conda-forge apptainer squashfuse
	fi
	conda activate apptainer
fi

export APPTAINER="$(which apptainer)"
echo "Using apptainer at $APPTAINER"

# Base container image
export BASEIMAGE=$NGM_OUTDIR/baseimage.sif

if ! [[ -f "$BASEIMAGE" ]]; then
	echo "Building base image"
	apptainer build "$BASEIMAGE" $SCRIPT_DIR/baseimage.def
fi

echo "Container base image at $BASEIMAGE"

# Set up conda local repo
if ! [[ -d "$MAMBA_REPO" ]]; then
	mkdir -p "$MAMBA_REPO"/noarch
	echo "{}" >> "$MAMBA_REPO"/noarch/repodata.json
	bzip2 --keep "$MAMBA_REPO"/noarch/repodata.json
fi

# Conda packages
if ! [[ -d "$TMPDIR/conda-pkgs" ]]; then
	git clone git@git.nci.org.au:bom/ngm/conda-pkgs "$TMPDIR/conda-pkgs"
	for pkg in "$TMPDIR"/conda-pkgs/*/meta.yaml; do
		sed -i "$pkg" \
			-e "s%file:///g/data/ki32/mosrs/%https://code.metoffice.gov.uk/svn/%"
	done
fi
for pkg in "$TMPDIR"/conda-pkgs/*; do
	pkg_name="$(basename "$pkg")"
	if ! [[ -f "$pkg/meta.yaml" ]]; then
		# Not a conda package
		continue
	fi
	if ! grep "$pkg_name" "$SCRIPT_DIR/../envs/$BASE_ENV/mamba.yaml" > /dev/null; then
		# Package not used in this env
		continue
	fi
	if ! [[ -f "$(conda build --output-folder "$MAMBA_REPO" --output "$pkg")" ]]; then
		conda build --output-folder "$MAMBA_REPO" "$pkg"
	fi
done

# Clean any previous build
if [[ -d "$SQUASHFS_ROOT" ]]; then
	rm -r "$SQUASHFS_ROOT"
fi

# Build conda environment
unset conda
bash $SCRIPT_DIR/build_part1.sh
bash $SCRIPT_DIR/build_part2.sh
