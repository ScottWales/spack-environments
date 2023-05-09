# NGM Spack Environments & Containers

## Repository Layout

* `bin/`: User scripts
* `ci/`: CI scripts
* `config/`: Spack config files
* `containers/`: Dockerfiles
* `envs/`: Environments
* `etc/`: Config files and build scripts
* `repos/`: Spack Packages

## Using containers

### Run container on Gadi

Load the container module

    module use /scratch/hc46/hc46_gitlab/ngm/modules
    module load lfric-v0/gcc-openmpi

The `imagerun` helper script will run a command in the container

    imagerun unifiedmodel_hofx.x

`imagerun` will also set up bind mode MPI automatically, use it inside of `mpirun`

    mpirun -n 4 imagerun unifiedmodel_hofx.x

### Run container on a generic system

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

The instance should be running Amazon Linux. Spack, Mamba and their
dependencies will be installed if not present.

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

    ./bin/install.sh lfric-v0

will install the `lfric-v0` environment with that compiler and MPI.
