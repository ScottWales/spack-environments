#!/bin/bash

# Set up containers on a bare amazonlinux image

set -eu
set -o pipefail

export SCRIPT_DIR=$( cd -- "$( dirname -- "$(readlink -f ${BASH_SOURCE[0]})" )" &> /dev/null && pwd )

# Install conda and dependencies
MAMBA_ROOT=~/conda
if ! [[ -f "$MAMBA_ROOT/bin/conda" ]]; then
	mkdir -p $MAMBA_ROOT
	pushd $MAMBA_ROOT
	curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
	bash Mambaforge-Linux-x86_64.sh -b -f -p $MAMBA_ROOT

	$MAMBA_ROOT/bin/conda install --yes -n base conda-build subversion apptainer squashfuse cylc-flow cylc-rose metomi-rose
	popd
fi
source $MAMBA_ROOT/etc/profile.d/conda.sh
conda activate base

# Set up passwordless SSH
if ! [[ -f /usr/bin/pinentry-curses ]]; then
        cat <<EOF

ERROR: Unable to find pinentry-curses.
       Please run:

           sudo dnf install pinentry-curses
EOF
        exit 1
fi
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

# Need to enter password twice for svn to store it
svn info https://code.metoffice.gov.uk/svn/um
svn info https://code.metoffice.gov.uk/svn/um

# Now should have the password cached
svn --non-interactive info https://code.metoffice.gov.uk/svn/um

# Run the generic build script
bash $SCRIPT_DIR/build_generic.sh
