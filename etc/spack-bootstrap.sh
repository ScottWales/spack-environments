#!/bin/bash

# Install Spack
wget https://github.com/spack/spack/releases/download/v${SPACK_VERSION}/spack-${SPACK_VERSION}.tar.gz | tar -C $SPACK_ROOT -xv

# Activate Spack
source $SPACK_ROOT/share/spack/setup-env.sh

# Install the CI mirror and package repos
spack mirror add --scope site ci-mirror file://$SPACK_CACHE
spack repo add --scope site $SPACK_ROOT/var/spack/repos/jopa

# Update Spack with system packages
spack compiler find --scope site
spack external find --scope site --all
spack bootstrap now

# List the found environment
spack compilers
spack find
