# Environment CI

Containers are built automatically by Gitlab CI. This happens in the following stages:

1. Build base docker image. This is based on rockylinux8 to match Gadi, and
   includes system packages, spack and mamba.

2. Lock container environments. `spack concretize` and `conda-lock` are used to
   define the container's environments. Containers only get rebuilt if their
   lock files change.

3. Build Spack packages. Spack's Gitlab CI integration is used so that only
   packages that have changed need to get rebuilt.

4. Build containers. Containers whos lock files have changed get rebuilt, which
   happens in further steps

    1. Build spack-env docker image. This builds spack and mamba environments
       from the lock files, and sets up environment variables based on the
       environment definition.

    2. Convert the docker image to apptainer format. Unlike building the
       container from scratch with apptainer converting formats does not
       require root permissions.

    3. Stage the container onto Gadi under /scratch/hc46/hc46_gitlab/ngm. The
       container can then be tested and installed manually to /g/data/access.
