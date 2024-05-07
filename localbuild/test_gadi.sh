#!/bin/bash

# Test the container on AWS

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )


BUILDDIR=/scratch/$PROJECT/$USER/tmp/lfric
IMAGERUN=/scratch/$PROJECT/$USER/tmp/ngm/lfric-v0-intel-openmpi/bin/imagerun

# Store MOSRS password
/g/data/hr22/apps/mosrs-setup/2.0.1/bin/mosrs-auth

if ! [[ -d "$BUILDDIR" ]]; then
	mkdir "$BUILDDIR"
	svn co https://code.metoffice.gov.uk/svn/lfric/LFRic/trunk "$BUILDDIR/lfric_core"
	svn co https://code.metoffice.gov.uk/svn/lfric_apps/main/trunk "$BUILDDIR/lfric_apps"
fi

export NGMENV_DEBUG=1

APP=lfric_atm
"$IMAGERUN" fcm kp

# Build the app
pushd "$BUILDDIR/lfric_apps"
"$IMAGERUN" build/local_build.py \
	--application "$APP" \
	--core_source "$BUILDDIR/lfric_core" \
	--working_dir "$BUILDDIR/build"
popd

# Run the app example
pushd "$BUILDDIR/lfric_apps/applications/$APP/example"
"$IMAGERUN" "../bin/$APP" configuration.nml
popd
