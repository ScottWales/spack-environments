# JOPA Spack Containers

## Repository Layout

* `bin/`: User scripts
* `ci/`: CI scripts
* `containers/`: Dockerfiles
* `envs/`: Environments
* `repos/`: Spack Packages

## Using containers

Run from a container using Apptainer

    apptainer run jopa-intel-openmpi.sif unifiedmodel_hofx.x

Configure Bind-mode MPI by mounting your system MPI to /bind/openmpi@4

    mpirun -n 4 apptainer run --bind /apps/openmpi/4.1.4:/bind/openmpi@4 \
        jopa-intel-openmpi.sif unifiedmodel_hofx.x

## Installing on a bare system

### Installing environments on NCI Gadi

To install an environment on Gadi run

    ./bin/install_gadi.sh ENV

with ENV the name of a directory under `envs/`.

### Installing environments on AWS EC2

To install an environment on EC2 run

    ./bin/install_aws.sh ENV

The instance should be running Amazon Linux

### Installing environments on a generic system

Installing an environment locally requires `spack` and `mamba` to be installed
and active.

To install an environment run

    ./bin/install.sh ENV

### Setting Compiler and MPI version

By default the environment will be built with Spack's defaults for compiler and MPI.

To use a different version set the `SPACK_COMPILER` and `SPACK_MPI` environment
variables, e.g.

    export SPACK_COMPILER=intel@2021.8.0
    export SPACK_MPI=openmpi@4.1.4

    ./bin/install.sh lfric_v0

will install the `lfric_v0` environment with that compiler and MPI.

## Using the envionment

To load an environment run

    ./bin/activate.sh ENV
