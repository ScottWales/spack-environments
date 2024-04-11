#!/bin/bash
#  Copyright 2024 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Container to build
export BASE_ENV=nemo-v4
export VARIANT=gcc-openmpi
export QUEUE=normal

PBS_FLAGS="-v PROJECT,SCRIPT_DIR,BASE_ENV,VARIANT"

# Run tasks requiring network
PART1=$(qsub $PBS_FLAGS build_part1.sh)

# Run main spack build
PART2=$(qsub -q $QUEUE -W depend=afterok:${PART1} $PBS_FLAGS build_part2.sh)

source env.sh
cat <<EOF
PBS tasks ${PART1} ${PART2}

Container commands will be available under

    $APPDIR/bin

when the build completes
EOF
