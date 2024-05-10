#!/bin/bash

# Test the container on AWS

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

MAMBA_ROOT=~/conda

source $MAMBA_ROOT/etc/profile.d/conda.sh
conda activate base
env | grep CONDA

export GPG_AGENT_INFO=`gpgconf --list-dirs agent-socket | tr -d '\n' && echo -n ::`
export GPG_TTY=$(tty)
env | grep GPG

gpg-connect-agent reloadagent /bye
svn info https://code.metoffice.gov.uk/svn/um
svn --non-interactive info https://code.metoffice.gov.uk/svn/um
if ! [[ -d ~/lfric ]]; then
	svn co https://code.metoffice.gov.uk/svn/lfric/LFRic/trunk ~/lfric/lfric_core
	svn co https://code.metoffice.gov.uk/svn/lfric_apps/main/trunk ~/lfric/lfric_apps
fi

export NGMENV_DEBUG=1

APP=lfric_atm
~/ngm/lfric-v0-intel-openmpi/bin/imagerun fcm kp

pushd ~/lfric/lfric_apps
~/ngm/lfric-v0-intel-openmpi/bin/imagerun build/local_build.py \
	--application "$APP" \
	--core_source ~/lfric/lfric_core \
	--working_dir ~/lfric/build
popd

pushd ~/lfric/lfric_apps/applications/"$APP"/example
~/ngm/lfric-v0-intel-openmpi/bin/imagerun "../bin/$APP" configuration.nml
popd
