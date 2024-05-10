# Environments

The container environment definitions are held in the [envs/](/envs/)
directory. Environments generally contain both a Conda and Spack environment -
the Conda environment holding python-based dependencies and the Spack
environment holding binary dependencies.

Environments can have 'variants', which are usually different combinations of
compilers and MPI implementations, with all the other dependencies kept constant.

See [Container Contents](contents.md) for details on how to set up new environments.

## lfric

Dependencies required to build the LFRic atmosphere model.

The model should be both built and run in the container environment. A `rose`
wrapper is included which will automatically set this up inside Rose suites
when the container executables are on a task's `$PATH`.

## nemo

Dependencies required to build the Nemo ocean model.

The model should be both built and run in the container environment, e.g. by
prepending commands with the container's `imagerun` script.

## jopa

Dependencies required to build the Jopa and Jada data assimilation tools.

The model should be both built and run in the container environment, e.g. by
prepending commands with the container's `imagerun` script.

## metplus

Full environment for running METplus and CSET verification.

Wrappers for `python`, `run_metplus.py`, `validate_config.py`, `cset` and
`juptyer` are included in the environment's `bin/` directory, these wrappers
will automatically run the matching command inside the container.
