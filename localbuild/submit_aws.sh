#!/bin/bash

# Set up containers on a bare amazonlinux image

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Install conda and dependencies
MAMBA_ROOT=~/conda
mkdir -p $MAMBA_ROOT
if ! [[ -f "$MAMBA_ROOT/bin/conda" ]]; then
	pushd $MAMBA_ROOT
	curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
	bash Mambaforge-Linux-x86_64.sh -b -f -p $MAMBA_ROOT

	$MAMBA_ROOT/bin/conda install --yes -n base conda-build subversion apptainer squashfuse cylc cylc-rose metomi-rose
	popd
fi
source $MAMBA_ROOT/etc/profile.d/conda.sh
conda activate base

# Set up passwordless SSH
if ! [[ -f ~/.gnupg/gpg-agent.conf ]]; then
	mkdir ~/.gnupg
	cat > ~/.gnupg/gpg-agent.conf <<EOF
allow-preset-passphrase
pinentry-program /usr/bin/pinentry-curses
max-cache-ttl 43200
EOF
	gpg-connect-agent reloadagent /bye
fi
export GPG_AGENT_INFO=`gpgconf --list-dirs agent-socket | tr -d '\n' && echo -n ::`
export GPG_TTY=$(tty)

# Check svn is working
echo "Storing MOSRS password in gpg-agent"
svn info https://code.metoffice.gov.uk/svn/um
svn info https://code.metoffice.gov.uk/svn/um

# Run the generic build script
bash $SCRIPT_DIR/submit_generic.sh
