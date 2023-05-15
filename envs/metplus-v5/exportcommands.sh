#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail


# List commands to be exported from the container when it's installed
METPATH=$(spack find --format '{prefix}' met)
METPLUSPATH=$(spack find --format '{prefix}' metplus)

ls -1 $METPATH/bin

echo run_metplus.py
echo validate_config.py
