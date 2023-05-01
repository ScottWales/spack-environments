#!/bin/bash
set -eu

source /opt/spack/share/spack/setup-env.sh

# Generates Spack CI yaml files
: ${CI_PROJECT_DIR:=.}
export CI_PROJECT_DIR
ARTIFACTS=${CI_PROJECT_DIR}/artifacts

SPACK_COMPILERS="gcc@8.5.0 intel@2021.8.0"
SPACK_MPIS="openmpi@4.1.4"

mkdir -p build

# Concretize each enviornment separately
for env in envs/*/spack.yaml; do
        for SPACK_COMPILER in $SPACK_COMPILERS; do
                for SPACK_MPI in $SPACK_MPIS; do
                        ENV=$(basename $(dirname $env))
			BUILD=$ENV-$SPACK_COMPILER-$SPACK_MPI
			echo $BUILD

			# Setup the build directory
			mkdir -p build/ci-$BUILD/
                        cp $env build/ci-$BUILD/

			# Activate the environment, set the compiler/mpi, and concretize
                        spack env activate --without-view build/ci-$BUILD
			spack config add "config:install_missing_compilers:true"
                        spack config add "packages:all:require:'%$SPACK_COMPILER'"
                        spack config add "packages:mpi:require:$SPACK_MPI"
			spack compilers
                        spack concretize --force --fresh
                        spack env deactivate

			# Copy the concretized environment to the artifacts directory for deployment
			cp -r build/ci-$BUILD $ARTIFACTS/
                done
        done
done

# Merge lock files from all concretized environments
echo merged
spack env create -d build/merged
bin/merge_spack_lock.py --ci-yaml=ci/spack-ci.yaml --output=build/merged build/ci-*/spack.lock

# CI generate
spack env activate --without-view build/merged
spack ci generate --check-index-only --artifacts-root $ARTIFACTS --output-file $ARTIFACTS/pipeline.yml
