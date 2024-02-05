# Creating Containerised Environments

Environment definitions are stored under the `envs/` directory. These can hold
the following files:

* `spack.yaml`: Spack environment definition
* `mamba.yaml`: Mamba/conda environment definition
* `envs.activate.sh`: Extra environment variable settings
* `exportcommands.sh`: Script that lists commands to make available in the
  module
* `variants/*.yaml`: Defines container variants

## Variants

Variants allow the same container to be created using different compilers and
MPI implementations. They are defined in the enviornment's `variants/`
subdirectory as Spack configurations that get merged into the main `spack.yaml`
file for that enviornment. For example, `lfric-v0/variants/intel-openmpi.yaml`
defines the `intel-openmpi` variant for the `lfric-v0` container, and looks like
```yaml
spack:
    packages:
        all:
            require: "%intel@2021.8.0"
        mpi:
            require: "openmpi@4.1.4"
```

Containers will only be built using CI if their environments change.

## Installing Environments on Gadi

The container will be created automatically by Gitlab CI and installed to the
staging area `/scratch/hc46/hc46_gitlab/ngm/apps/$ENV-v$VERSION/$VARIANT-$BRANCH`.

The installation directory for containerised environments is
`/g/data/access/ngm/envs/$ENV/$VERSION/$VARIANT`. The staging directory should
be manually copied to the installation directory once initial testing is
complete.

A matching module file should be created at
`/g/data/access/ngm/modules/envs/$ENV/$VERSION/$VARIANT`. This file should be
copied from `/scratch/hc46/hc46_gitlab/ngm/modules/$ENV-v$VERSION/$VARIANT-$BRANCH`.
The `appdir` variable needs to be updated to the final install path.

