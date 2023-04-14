#!/bin/bash

# Install Spack
wget -O - https://github.com/spack/spack/releases/download/v${SPACK_VERSION}/spack-${SPACK_VERSION}.tar.gz | tar xz -C $SPACK_ROOT --strip-components=1 

# Activate Spack
source $SPACK_ROOT/share/spack/setup-env.sh

# Install the CI mirror and package repos
spack mirror add --scope site ci-mirror file://$SPACK_CACHE
spack repo add --scope site $SPACK_ROOT/var/spack/repos/jopa

# Update Spack with system packages
spack compiler find --scope site /usr
spack external find --scope site --all --path /usr --not-buildable
spack bootstrap now

spack env create --without-view base

# List the found environment
spack compilers
spack find
