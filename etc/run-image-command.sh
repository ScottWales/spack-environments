#!/bin/bash
#  Copyright 2022 Bureau of Meteorology
#  Author Scott Wales

# Symlink a command name to this script to be able to run it from the container
# e.g.
#    ln -s ncdump /path/to/run-image-command.sh
# then `ncdump` will run that command from the container

set -eu
set -o pipefail

# Only use libraries inside the image
# SETUP: Comment out to allow user libraries
export PYTHONNOUSERSITE=1
export PYTHONPATH=""

SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

$SCRIPT_DIR/imagerun $(basename $0) "$@"
