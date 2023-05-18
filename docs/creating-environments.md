# Creating Containerised Environments

Environment definitions are stored under the `envs/` directory. These can hold
the following files:

* `spack.yaml`: Spack environment definition
* `mamba.yaml`: Mamba/conda environment definition
* `envs.activate.sh`: Extra environment variable settings
* `exportcommands.sh`: Script that lists commands to make available in the
  module

## Installing Environments on Gadi

The container will be created automatically by Gitlab CI and installed to the
staging area `/scratch/hc46/hc46_gitlab/ngm/apps/$ENV-v$VERSION/$VARIANT`.

The installation directory for containerised environments is
`/g/data/access/ngm/envs/$ENV/$VERSION/$VARIANT`. The staging directory should
be manually copied to the installation directory once initial testing is
complete.

A matching module file should be created at
`/g/data/access/ngm/modules/envs/$ENV/$VERSION/$VARIANT`. This file should be
copied from `/scratch/hc46/hc46_gitlab/ngm/modules/$ENV-v$VERSION/$VARIANT`.
The `appdir` variable needs to be updated to the final install path.

