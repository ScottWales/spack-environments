# Building the Container

The containers can be built either automatically using Gitlab CI or manually
using local build scripts.

## On Gitlab CI

Gitlab CI will automatically build all available container definitions to make
sure that all recipes are consistent. The build happens in several stages, with
some steps being automatically skipped if no changes have been made.

Cached pacakges and base containers are stored on the Gitlab Runner's file
system instead of as CI artefacts.

1. Setup - creates cache directories on the filesystem
2. Base - create base docker image
3. Generate - creates lock files for Conda and Spack environments and a list of
   containers that have changed and need to be rebuilt
4. Package Build - builds Spack packages using Spack's Gitlab-CI integration
5. Container Build - builds squashfs overlays for each container, installs
   them on top of the base image then deploys the container
5. Cleanup - removes built containers from the runner filesystem

On Gadi the CI built container are available in the hc46 project, and can be loaded with
```
module use /scratch/hc46/hc46_gitlab/ngm/modules
module load $BASE_ENV/$VARIANT-$BRANCH
```

## At NCI

Containers can be built locally at NCI using the script
`localbuild/build_gadi.sh`. Adjust `$BASE_ENV` and `$VARIANT` in the script to
the name of the container you wish to build.

NCI's HPC compute nodes do not have internet access, so the container builds
are split into two stages. Stage 1 sets up the Conda environment and downloads
source code required for Spack packages, Stage 2 builds the Spack packages and
runs on the compute nodes.

The base image is prebuilt and stored in Git LFS as creating this requires root
permissions. The base image definition is stored at
[localbuild/baseimage.def](/localbuild/baseimage.def).

See [Using the Container](using.md) or the environment documentation for
how to use the container.

## At AWS

The script [localbuild/build_aws.sh](/localbuild/build_aws.sh) will build a
container on an AWS EC2 instance. Recommended EC2 settings are an `amazonlinux`
based image and at least 20 GB of storage. Adjust `$BASE_ENV` and `$VARIANT` in
the script to the name of the container you wish to build.

The build script will install Conda and create an environment with Apptainer
installed before building the image.

See [Using the Container](using.md) or the environment documentation for
how to use the container.

## Elsewhere

The script [localbuild/build_generic.sh](/localbuild/build_generic.sh) can be
used as a starting point for building containers on other sites. It reuses the
Gitlab CI scripts to make the resulting container as close as possible to what
gets built on CI.

The build process itself is split into two sections - part 1 requires network
access, while part 2 requires more compute power. On a HPC these parts may
require running on different queues.

See [Using the Container](using.md) or the environment documentation for
how to use the container.
