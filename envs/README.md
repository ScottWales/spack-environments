# Containerised Environments

The enviornments use Spack for binary dependencies where we want to compile
with different compilers and MPIs, and Mamba for Python dependencies where we
want to make use of packages on conda-forge.

The Spack and Mamba environments are somewhat integrated - Spack is set up to
use the Mamba environment as its Python implementation.

## Environment Contents

* `spack.yaml`: Spack configuration
* `mamba.yaml`: Mamba configuration
* `env.activate.sh`: Extra environment variable settings

## Variants

The variants directory contains the different pre-requisites we want to build
each environment with. These are Spack environment configuration files that get
merged with the main `spack.yaml` file.

For example, `lfric/0.1/variants/gcc-openmpi.yaml` looks like
```yaml
spack:
    packages:
        all:
            require: "%gcc@8.5.0"
        mpi:
            require: "openmpi@4.1.4"
```
These configurations are merged with `lfric/0.1/spack.yaml` to create the
`lfric/0.1/gcc-openmpi` container environment.
