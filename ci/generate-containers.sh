#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

mkdir -p artifacts

# Default to master branch cache if this branch doesn't have one
if ! [ -d "$BRANCH_CACHE" ]; then
    BRANCH_CACHE="$BRANCH_CACHE/../master"
fi
echo "BRANCH_CACHE=$BRANCH_CACHE"

MATRIX="["
for env in envs/*/spack.yaml; do
    ENV=$(basename $(dirname $env))
    echo "ENV=$ENV"

    for variant in $(dirname $env)/variants/*.yaml; do
        if [ -f $variant ]; then
            VAR=$(basename --suffix=.yaml $variant)
        else
            VAR=default
        fi

        BUILD=$ENV-$VAR
        echo "VAR=$VAR"

        # Skip 'base' environment
        if [ $ENV = "base" ]; then continue; fi

        # Copy config files to this variant
        cp -r --no-clobber envs/$ENV/* artifacts/ci-$BUILD/
        cp containers/spack-env.docker artifacts/ci-$BUILD

        # If there is a conda environment copy the lock to this variant
        if [ -f envs/$ENV/mamba.yaml ]; then
            mkdir -p artifacts/ci-$BUILD
            cp artifacts/$ENV/mamba.lock artifacts/ci-$BUILD/mamba.lock
        fi

        # See if this container was already built
        HAS_DIFF="no"
        if [ -d "$BRANCH_CACHE/ci-$BUILD" ]; then
            # Do config files differ?
            if ! diff -q -r --exclude variants --exclude spack.lock "$BRANCH_CACHE/ci-$BUILD" "artifacts/ci-$BUILD"; then
                HAS_DIFF="yes"
            fi
            # Do lock files differ? - special because files are not consistently ordered
            if ! ci/diff-spack-lock.py "$BRANCH_CACHE/ci-$BUILD/spack.lock" "artifacts/ci-$BUILD/spack.lock"; then
                HAS_DIFF="yes"
            fi
        else
            HAS_DIFF="yes"
        fi

        echo "HAS_DIFF=$HAS_DIFF"

        if [ $HAS_DIFF = "yes" ]; then
            MATRIX="$MATRIX {'BASE_ENV':'$ENV', 'VARIANT':'$VAR', 'CONCRETE_ENV':'$BUILD'},"
        fi
    done
done
MATRIX="$MATRIX ]"

sed -e "s?__MATRIX__?${MATRIX}?" \
    -e "s?__PIPELINE_ID__?${CI_PIPELINE_ID}?" \
    ci/containers.yml > artifacts/containers.yml

if [ "$MATRIX" = "[ ]" ]; then
# Nothing to build
cat > artifacts/containers.yml << EOF
stages:
 - noop
nothing to build:
  stage: noop
  tags: [docker]
  script: "/bin/true"
EOF
fi
