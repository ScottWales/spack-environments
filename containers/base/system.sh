#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

# Base packages
microdnf install -y --nodocs \
     bzip2-devel \
     cmake \
     curl-devel \
     gcc \
     gcc-c++ \
     gcc-gfortran \
     git \
     gzip \
     libasan \
     liblsan \
     libtool \
     libtsan \
     libubsan \
     openssl-devel \
     patch \
     perl \
     perl-ExtUtils-MakeMaker \
     perl-XML-Parser \
     procps \
     shadow-utils \
     subversion \
     tar \
     time \
     unzip \
     wget \
     which \
     xz-devel \
     zstd

microdnf clean all

# Mamba user
useradd mamba --home-dir $MAMBA_ROOT --no-create-home
mkdir -p $MAMBA_ROOT
chown -R mamba $MAMBA_ROOT

# Spack user
useradd spack --home-dir $SPACK_ROOT --no-create-home
mkdir -p $SPACK_ROOT
chown -R spack $SPACK_ROOT

