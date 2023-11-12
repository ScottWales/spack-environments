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

JOBS=""
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
        cp -r containers/spack-env artifacts/ci-$BUILD

        # If there is a conda environment copy the lock to this variant
        if [ -f envs/$ENV/mamba.yaml ]; then
            mkdir -p artifacts/ci-$BUILD
            cp artifacts/$ENV/mamba.lock artifacts/ci-$BUILD/mamba.lock
        fi

        # Copy etc files into the cache
        cp -r etc artifacts/ci-$BUILD/etc

        # See if this container was already built
        HAS_DIFF="no"
        if [ -d "$BRANCH_CACHE/ci-$BUILD" ]; then
            # Do config files differ?
            if ! diff -q -r --exclude variants --exclude spack.lock --exclude mamba.lock "$BRANCH_CACHE/ci-$BUILD" "artifacts/ci-$BUILD"; then
                HAS_DIFF="yes"
            fi
            # Do lock files differ? - special because files are not consistently ordered
            if ! ci/diff-spack-lock.py "$BRANCH_CACHE/ci-$BUILD/spack.lock" "artifacts/ci-$BUILD/spack.lock"; then
                HAS_DIFF="yes"
            fi

            if [ -f "artifacts/ci-$BUILD/mamba.lock" ]; then
                if ! ci/diff-mamba-lock.py "$BRANCH_CACHE/ci-$BUILD/mamba.lock" "artifacts/ci-$BUILD/mamba.lock"; then
                    HAS_DIFF="yes"
                fi
            fi
        else
            HAS_DIFF="yes"
        fi

        echo "HAS_DIFF=$HAS_DIFF"

        if [ $HAS_DIFF = "yes" ]; then
            JOBS="$BUILD $JOBS"
            sed \
                -e "s?__BASE_ENV__?${ENV}?" \
                -e "s?__CONCRETE_ENV__?${BUILD}?" \
                -e "s?__PIPELINE_ID__?${CI_PIPELINE_ID}?" \
                -e "s?__VARIANT__?${VARIANT}?" \
                ci/containers.yml >> artifacts/containers.yml
        fi
    done
done

if [ -n "$JOBS" ]; then
cat >> artifacts/containers.yml <<EOF

stages:
    - docker
    - apptainer
    - stage
    - clean

EOF

else

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
