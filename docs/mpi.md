# Containers and MPI

There are two modes that containers can run in for MPI:

 * Hybrid Mode: mpirun comes from outside the container, libmpi.so comes from
   inside the container
 * Bind Mode: both mpirun and libmpi.so come from outside the container

Generally Bind mode will have higher performance as it can use fabric
optimisations from the host HPC.

At NCI the container is preset to use bind-mode MPI. With the container module
loaded `mpirun` commands will automatically start the container on all nodes.
`mpirun` can also be run from inside the container if needed, inside the
container it uses a wrapper to call out to the host `mpirun`.

Bind-mode MPI can be disabled by setting the variable
`NGMENV_MPI_HYBRID_MODE_ONLY` to a non-empty value

When setting up the container on a new site it's important that the container's
`mpirun` is not used as that will not be able to start processes across
multiple nodes. With OpenMPI the environment variable
`OMPI_MCA_orte_launch_agent` can be used to configure how nodes start, this should
eventually call `orted`.

## Implementation

Activation of MPI is set up in `containers/install-spack-env.sh`, creating the
file `$SPACK_ROOT/bin/activate.sh` in the container.

The container's `libmpi.so` is stored under
`HYBRID_MPI_LIB=$SPACK_ROOT/containermpi/lib_hybrid_mpi`. `$LD_LIBRARY_PATH`
looks like `$SPACK_ENV_VIEW/lib:$HOST_MPI/lib:$HYBRID_MPI_LIB`, so that the
host MPI libraries are picked up in preference to the container MPI libraries.
In hybrid mode `$HOST_MPI` is not mounted so the container MPI is what gets
picked up.

The mpirun wrapper is also created by `containers/install-spack-env.sh`, it is
stored within the container at `$SPACK_ROOT/containermpi/bin`. The wrapper
calls `$HOST_MPI/bin/mpirun` if available, otherwise it calls the internal
mpirun.
