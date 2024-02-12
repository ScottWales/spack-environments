#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

# Base packages
microdnf install -y --nodocs \
     bzip2 \
     bzip2-devel \
     curl \
     diffutils \
     file \
     findutils \
     gcc \
     gcc-c++ \
     gcc-gfortran \
     git \
     gzip \
     make \
     openssl \
     openssl-devel \
     patch \
     squashfs-tools \
     tar \
     time \
     unzip \
     wget \
     which \
     xz \
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

