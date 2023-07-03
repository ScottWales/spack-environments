#!/bin/bash
set -eu

source /opt/spack/share/spack/setup-env.sh

spack repo list
ls -l /opt/spack/var/spack/repos/
ls -l /opt/spack/var/spack/repos/bom-ngm
ls -l /opt/spack/var/spack/repos/jopa


# Generates Spack CI yaml files
: ${CI_PROJECT_DIR:=.}
export CI_PROJECT_DIR
ARTIFACTS=${CI_PROJECT_DIR}/artifacts

mkdir -p build
mkdir -p ${ARTIFACTS}

# Concretize each enviornment separately
for env in envs/*/spack.yaml; do
    for variant in $(dirname $env)/variants/*.yaml; do
        if [ -f $variant ]; then
            VAR=$(basename --suffix=.yaml $variant)
        else
            VAR=default
        fi

        ENV=$(basename $(dirname $env))
        BUILD=$ENV-$VAR
        echo $BUILD

        # Setup the build directory
        mkdir -p build/ci-$BUILD/
        cp $env build/ci-$BUILD/

        # Activate the environment, set the compiler/mpi, and concretize
        spack env activate --without-view build/ci-$BUILD
        if [ -f $variant ]; then
            spack config add --file $variant
        fi
        spack concretize --force --fresh
        spack env deactivate

        # Copy the concretized environment to the artifacts directory for deployment
        mkdir $ARTIFACTS/ci-$BUILD
        cp -v build/ci-$BUILD/spack.{yaml,lock} $ARTIFACTS/ci-$BUILD
    done
done

# Merge lock files from all concretized environments
echo merged
spack env create --without-view -d build/merged
bin/merge_spack_lock.py --ci-yaml=ci/spack-ci.yaml --output=build/merged build/ci-*/spack.lock

# CI generate
spack env activate --without-view build/merged

spack ci generate --check-index-only --artifacts-root $ARTIFACTS --output-file $ARTIFACTS/pipeline.yml
