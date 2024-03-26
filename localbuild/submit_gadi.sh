#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

source env.sh

# Run tasks requiring network
PART1=$(qsub build_part1.sh)

# Run main spack build
PART2=$(qsub -W depend=afterok:${PART1} build_part2.sh)

cat <<EOF
PBS tasks ${PART1} ${PART2}

Container commands will be available under

    $APPDIR/bin

when the build completes
EOF
