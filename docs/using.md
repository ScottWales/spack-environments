# Using the Container

The container is built as an [Apptainer](https://apptainer.org/) and
[Singularity](https://docs.sylabs.io/guides/latest/user-guide/) compatible
image.

A helper script called `imagerun` is provided that will set up the correct
flags for running the image with bind-mode MPI. Symlinks to imagerun will run a
command with the name of the symlink inside the container, so for instance a
symlink named `python` to the imagerun command would run the container's
`python`.

The container is installed into a directory named `$ENV-$VARIANT`, with
`imagerun` and command symlinks in the `bin/` directory and the container image
itself in the `etc/` directory. This `$ENV-$VARIANT` directory can be safely
moved or renamed without affecting the container.

## At NCI

Centrally installed containers are set up with a modulefile that will load the
correct MPI implementation and put the container's commands on your `$PATH`.

If you [build the container manually](building.md#at-nci) you will find the
container commands by default under
`/scratch/$PROJECT/$USER/tmp/$ENV-$VARIANT/bin`. You will need to load the MPI
library manually.

## At AWS

If you [build the container manually](building.md#at-aws) you will find the
container commands by default under `~/ngm/$ENV-$VARIANT/bin`. You will need to
install MPI using `sudo dnf install mpi`.

## Elsewhere

If you use the [generic build script](building.md#elsewhere) you will find the
container commands by default under `~/ngm/$ENV-$VARIANT/bin`. You can change
`$NGM_OUTDIR` in the build script to install the container to a different
location.
