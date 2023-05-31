#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

MATRIX="["
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

        # Skip 'base' environment
        if [ $ENV = "base" ]; then continue; fi

        MATRIX="$MATRIX {'ENV':'$ENV', 'VARIANT':'$VAR'},"
    done
done
MATRIX="$MATRIX ]"

mkdir -p artifacts
sed -e "s?__MATRIX__?${MATRIX}?" \
    -e "s?__PIPELINE_ID__?${CI_PIPELINE_ID}?" \
    ci/containers.yml > artifacts/containers.yml
