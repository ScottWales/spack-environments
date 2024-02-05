# NEMO v4.0 Container

Container of packages required for running NEMO v4.0

This does not contain NEMO code or binaries, only the dependencies. This is intended to 
be referenced as a module from a cylc rose suite, which will build NEMO from source.

Packages:
  - Intel Compilers 2021.8.0
  - OpenMPI 4.1.4
  - fcm
  - netcdf
  - hdf5 1.12.2
  - libpng
  - openjpeg
  - zlib
  - XIOS 2.5
    <br/>(taken from revision 2252, with NEMO-specific patches from
    <br/>https://github.com/hiker/xios-2252/tree/master/patches)
