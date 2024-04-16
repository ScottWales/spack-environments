#!/bin/bash

set -eu

export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Install Spack
wget -O - https://github.com/spack/spack/releases/download/v${SPACK_VERSION}/spack-${SPACK_VERSION}.tar.gz | tar xz -C $SPACK_ROOT --strip-components=1 

# Activate Spack
source $SPACK_ROOT/share/spack/setup-env.sh

# Install the CI mirror and package repos
spack mirror add --scope site ci-mirror file://$SPACK_CACHE

# Temporary path to be copied in later
for repo in jopa bom-ngm; do
    mkdir -p $SPACK_ROOT/var/spack/repos/$repo/packages
    echo "repo: {namespace: $repo}" > $SPACK_ROOT/var/spack/repos/$repo/repo.yaml
    spack repo add --scope site $SPACK_ROOT/var/spack/repos/$repo
done

# Update Spack with system packages
spack compiler find --scope site /usr
spack external find --scope site --path /usr --not-buildable openssl
spack external find --scope site --path /usr --not-buildable subversion

spack config --scope site add packages:openssl:buildable:false
spack config --scope site add packages:gcc:buildable:true

function mamba_vn () {
    source $MAMBA_ROOT/etc/profile.d/conda.sh
    source $MAMBA_ROOT/etc/profile.d/mamba.sh
    # Extract version and trim to major.minor
    mamba list -n container "^$1\$" --json | sed -n 's/.*"version": "\([[:digit:]]\+\(\.[[:digit:]]\+\)\).*".*/\1/p'
}

cat > /tmp/packages.yaml << EOF
packages:
  python:
    externals:
    - spec: 'python@$(mamba_vn python)'
      prefix: $MAMBA_ROOT/envs/container
    buildable: False
  py-pip:
    externals:
    - spec: 'py-pip@$(mamba_vn pip)'
      prefix: $MAMBA_ROOT/envs/container
    buildable: False
  py-wheel:
    externals:
    - spec: 'py-wheel@$(mamba_vn wheel)'
      prefix: $MAMBA_ROOT/envs/container
    buildable: False
  py-setuptools:
    externals:
    - spec: 'py-setuptools@$(mamba_vn setuptools)'
      prefix: $MAMBA_ROOT/envs/container
    buildable: False
EOF
spack config --scope site add -f /tmp/packages.yaml
rm /tmp/packages.yaml

spack bootstrap now
spack bootstrap status

# List the found environment
spack compilers
spack find
