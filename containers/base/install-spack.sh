#!/bin/bash

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
spack external find --scope site --all --path /usr

spack config --scope site add packages:openssl:buildable:false
spack config --scope site add packages:gcc:buildable:true

function mamba_vn () {
    source $MAMBA_ROOT/etc/profile.d/conda.sh
    source $MAMBA_ROOT/etc/profile.d/mamba.sh
    mamba list "^$1\$" --json | sed -n 's/.*"version": "\([^"]\+\)".*/\1/p'
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

# Install intel compilers
spack install --no-check-signature intel-oneapi-compilers-classic@2021.8.0
ONEAPI_PREFIX=$(spack find --format '{prefix}' intel-oneapi-compilers)

# Minimise footprint
rm -rf $ONEAPI_PREFIX/compiler/latest/linux/lib/oclfpga
rm -rf $ONEAPI_PREFIX/compiler/latest/linux/lib/*_emu.so*
rm -rf $ONEAPI_PREFIX/compiler/latest/linux/bin-llvm
rm -rf $ONEAPI_PREFIX/intel
rm -rf $ONEAPI_PREFIX/conda_channel
rm -rf $ONEAPI_PREFIX/debugger

# Setup compilers
cat >> /opt/spack/etc/spack/compilers.yaml << EOF
- compiler:
    spec: oneapi@=$(spack find --format '{version}' intel-oneapi-compilers)
    paths:
      cc:  $ONEAPI_PREFIX/compiler/latest/linux/bin/icx
      cxx: $ONEAPI_PREFIX/compiler/latest/linux/bin/icpx
      f77: $ONEAPI_PREFIX/compiler/latest/linux/bin/ifx
      fc:  $ONEAPI_PREFIX/compiler/latest/linux/bin/ifx
    flags: {}
    operating_system: rocky8
    target: x86_64
    modules: []
    environment:
      prepend_path:
        LD_LIBRARY_PATH: "$ONEAPI_PREFIX/compiler/latest/linux/lib:$ONEAPI_PREFIX/compiler/latest/linux/lib/x64:$ONEAPI_PREFIX/compiler/latest/linux/compiler/lib/intel64_lin"
    extra_rpaths: []
- compiler:
    spec: intel@=$(spack find --format '{version}' intel-oneapi-compilers-classic)
    paths:
      cc:  $ONEAPI_PREFIX/compiler/latest/linux/bin/intel64/icc
      cxx: $ONEAPI_PREFIX/compiler/latest/linux/bin/intel64/icpc
      f77: $ONEAPI_PREFIX/compiler/latest/linux/bin/intel64/ifort
      fc:  $ONEAPI_PREFIX/compiler/latest/linux/bin/intel64/ifort
    flags: {}
    operating_system: rocky8
    target: x86_64
    modules: []
    environment:
      prepend_path:
        LD_LIBRARY_PATH: "$ONEAPI_PREFIX/compiler/latest/linux/lib:$ONEAPI_PREFIX/compiler/latest/linux/lib/x64:$ONEAPI_PREFIX/compiler/latest/linux/compiler/lib/intel64_lin"
    extra_rpaths: []
EOF

cat /opt/spack/etc/spack/compilers.yaml

spack clean

# List the found environment
spack compilers
spack find
