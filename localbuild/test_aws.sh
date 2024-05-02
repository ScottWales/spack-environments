#!/bin/bash

# Test the container on AWS

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

MAMBA_ROOT=~/conda

source $MAMBA_ROOT/etc/profile.d/conda.sh
conda activate base

export GPG_AGENT_INFO=`gpgconf --list-dirs agent-socket | tr -d '\n' && echo -n ::`
export GPG_TTY=$(tty)
if ! [[ -d ~/lfric ]]; then
	svn co https://code.metoffice.gov.uk/svn/lfric/LFRic/trunk ~/lfric/lfric_core
	svn co https://code.metoffice.gov.uk/svn/lfric_apps/main/trunk ~/lfric/lfric_apps
fi

export NGMENV_DEBUG=1

#pushd ~/lfric/lfric_apps
#~/ngm/lfric-v0-intel-openmpi/bin/imagerun build/local_build.py \
#	--application gungho_model \
#	--core_source ~/lfric/lfric_core \
#	--working_dir ~/lfric/build
#popd

pushd ~/lfric/lfric_apps/applications/gungho_model/example
~/ngm/lfric-v0-intel-openmpi/bin/imagerun ../bin/gungho_model configuration.nml
popd
