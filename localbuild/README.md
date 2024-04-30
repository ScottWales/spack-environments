# Building the container on the HPC

Run `submit_gadi.sh` to submit the two-stage container build

* `build_part1.sh` performs tasks that require internet access - setting up the
  Conda environment and downloading Spack sources, on Gadi this runs on copyq
* `build_part2.sh` performs spack package builds, on Gadi this runs on normal

Run `submit_generic.sh` to submit a one-stage container build

Requres:
 - conda
 - conda-build
 - passwordless svn to https://code.metoffice.gov.uk/svn
