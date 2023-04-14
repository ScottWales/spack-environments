# JOPA Spack Containers

## Repository Layout

* `/bin`: User scripts
* `/ci`: CI scripts
* `/containers`: Dockerfiles
* `/envs`: Environments
* `/repos`: Spack Packages

## Using containers

Run from a container using Apptainer

    apptainer run jopa-intel-openmpi.sif unifiedmodel_hofx.x

Configure Bind-mode MPI by mounting your system MPI to /bind/openmpi@4

    mpirun -n 4 apptainer run --bind /apps/openmpi/4.1.4:/bind/openmpi@4 \
        jopa-intel-openmpi.sif unifiedmodel_hofx.x

## Installing environments locally

To load the Spack packages and environments into your local Spack install:

    ./bootstrap.sh

To install an enviornment using your default Spack compiler and MPI:

    spack env activate jopa
    spack install

To install an environment using a different compiler or MPI:

    spack env create jopa-intel-openmpi envs/jopa/spack.yaml
    spack env activate jopa-intel-openmpi

    spack config add "packages:all:require:'%intel@2021.8.0'"
    spack config add "packages:mpi:require:'%openmpi@4.1.4'"

    spack install

