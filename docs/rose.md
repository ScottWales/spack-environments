# Containers and Rose

The container environment provides a wrapper around Rose, so that if the
environment is loaded any rose tasks get run within the container. You simply
need to load the container environment module before running `rose task-run` in
your suite:

```
[runtime]
    [[atmos]]
        init-script = """
        module load /g/data/access/ngm/modules/envs/lfric/0/intel-openmpi
        """
        script = "rose task-run"
```

## MPI tasks

When using `mpirun` you will need to add the `imagerun` wrapper around
the command to launch, e.g. `mpirun -n 4 imagerun gungho_model`. This ensures
that the container is properly launched on remote nodes. If you're running
mpirun in MPMD mode (i.e. a coupled model) `imagerun` should be in front of
each of the executables.

The `$IMAGERUN` environment variable can be useful to make configurations that
work both inside and outside the container. The environment module sets this to
`imagerun` when the container is available, so you can do something like:

```
mpirun -n 6 ${IMAGERUN:-} gungho_model : -n 2 ${IMAGERUN:-} xios_server
```

When the container is not loaded the `${IMAGERUN:-}`s will be discarded.
