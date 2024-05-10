# Environment Definitions

The environments use Spack for binary dependencies where we want to compile
with different compilers and MPIs, and Mamba for Python dependencies where we
want to make use of packages on conda-forge.

The Spack and Mamba environments are somewhat integrated - Spack is set up to
use the Mamba environment as its Python implementation.

## Environment Contents

Environment definitions are stored as directories under [envs/](/envs/). Each
directory should at least container a `spack.yaml` file.

* `spack.yaml`: [Spack environment configuration](https://spack.readthedocs.io/en/latest/environments.html)
* `mamba.yaml`: [Conda environment configuration](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-file-manually)
* `env.activate.sh`: Extra environment variable settings, sourced when the
  environment is activated
* `post-install.sh`: Extra install steps, run when the container is created
  after the Spack and Conda environments are created

## Variants

The variants/ directory in each environment contains the different
pre-requisites we want to build the environment with. These are Spack
environment configuration files that get merged with the main `spack.yaml`
file.

For example, `lfric-v0/variants/gcc-openmpi.yaml` looks like
```yaml
spack:
    packages:
        all:
            require: "%gcc@8.5.0"
        mpi:
            require: "openmpi@4.1.4"
```
These configurations are merged with `lfric-v0/spack.yaml` to create the
`lfric-v0/gcc-openmpi` container environment.

## Adding new packages

To add a new package to an environment add its name to either the `spack.yaml`
or `mamba.yaml` file. Generally Python packages should go into `mamba.yaml` and
everything else into `spack.yaml`. You can check what packages are available at
https://conda-forge.org/packages/ or https://packages.spack.io/.

## Adding new environments

To create a new environment make a new directory under `envs/` with at least a
`spack.yaml` file, see the existing environment definitions for ideas.
