#!/bin/bash
set -eu

# Generates Spack CI yaml files
: ${CI_PROJECT_DIR:=.}
export CI_PROJECT_DIR
ARTIFACTS=${CI_PROJECT_DIR}/artifacts

SPACK_COMPILERS="gcc@12.2.0 intel@2021.8.0"
SPACK_MPIS="openmpi@4.1.4"

mkdir -p build

# Concretize each enviornment
for env in envs/*/spack.yaml; do
        for SPACK_COMPILER in $SPACK_COMPILERS; do
                for SPACK_MPI in $SPACK_MPIS; do
                        ENV=$(basename $(dirname $env))
			echo $ENV-$SPACK_COMPILER-$SPACK_MPI
			mkdir -p build/ci-$ENV-$SPACK_COMPILER-$SPACK_MPI/
                        cp $env build/ci-$ENV-$SPACK_COMPILER-$SPACK_MPI/

                        spack env activate --without-view build/ci-$ENV-$SPACK_COMPILER-$SPACK_MPI
                        spack config add "packages:all:require:'%$SPACK_COMPILER'"
                        spack config add "packages:mpi:require:$SPACK_MPI"
                        spack concretize --force --fresh
                        spack env deactivate
                done
        done
done

# Merge lock files
mkdir -p build/merged
echo merged
bin/merge_spack_lock.py --ci-yaml=ci/spack-ci.yaml --output=build/merged build/ci-*/spack.lock

# CI generate
spack env activate --without-view build/merged
spack -d ci generate --artifacts-root $ARTIFACTS --output-file $ARTIFACTS/pipeline.yml
