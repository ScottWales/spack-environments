#!/bin/bash

export SPACK_PYTHON=$MAMBA_ROOT/envs/container/bin/python

# Install Spack
wget -O - https://github.com/spack/spack/releases/download/v${SPACK_VERSION}/spack-${SPACK_VERSION}.tar.gz | tar xz -C $SPACK_ROOT --strip-components=1 

# Activate Spack
source $SPACK_ROOT/share/spack/setup-env.sh

# Install the CI mirror and package repos
spack mirror add --scope site ci-mirror file://$SPACK_CACHE
spack repo add --scope site $SPACK_ROOT/var/spack/repos/jopa
spack repo add --scope site $SPACK_ROOT/var/spack/repos/bom-ngm

# Update Spack with system packages
spack compiler find --scope site /usr
spack external find --scope site --all --path /usr --not-buildable
spack external find --scope site --all --path $MAMBA_ROOT/envs/container --not-buildable

spack config --scope site add packages:gcc:buildable:true

function mamba_vn () {
    source $MAMBA_ROOT/etc/profile.d/conda.sh
    source $MAMBA_ROOT/etc/profile.d/mamba.sh
    mamba list $1 --json | sed -n 's/.*"version": "\([^"]\+\)".*/\1/p'
}

cat > /tmp/packages.yaml << EOF
packages:
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

#INTEL_COMPILER=intel-oneapi-compilers@2023.0.0
#spack install $INTEL_COMPILER intel-oneapi-compilers-classic
#
#INTEL_PREFIX=$(spack find --format '{prefix}' $INTEL_COMPILER)
#spack compiler find --scope site $INTEL_PREFIX/compiler/latest/linux/bin
#spack compiler find --scope site $INTEL_PREFIX/compiler/latest/linux/bin/intel64

spack clean

# List the found environment
spack compilers
spack find
