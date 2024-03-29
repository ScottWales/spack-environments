#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail


# List commands to be exported from the container when it's installed
METPATH=$(spack find --format '{prefix}' met)
METPLUSPATH=$(spack find --format '{prefix}' metplus)

ls -1 $METPATH/bin

# METplus commands
echo run_metplus.py
echo validate_config.py

# Python commands
echo python
echo python3
echo jupyter
echo cset
