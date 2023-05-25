#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

source $SPACK_ROOT/share/spack/setup-env.sh

spack env create container /build/spack.lock
spack env activate container
spack mirror add gitlab file://$SPACK_CACHE

spack install --use-buildcache=only --no-check-signature

export SPACK_ENV_VIEW=$SPACK_ENV/.spack-env/view

SPACK_MPI=$(spack find --format="{name}@{version}" mpi)
SPACK_COMPILER=$(spack find --format="{compiler}" mpi)

# Move MPI libs into a separate directory for Bind mode
MPI_PATH=$SPACK_ROOT/containermpi
mkdir -pv "$MPI_PATH/lib_hybrid_mpi"
for mpilib in libmpi.so libopen-rte.so libopen-pal.so; do
    mv -v $(spack find --format="{prefix}" mpi)/lib/${mpilib}* $MPI_PATH/lib_hybrid_mpi
    rm -v $SPACK_ENV_VIEW/lib/${mpilib}*
done

# Create activate script
cat > $SPACK_ROOT/bin/activate.sh << EOF
#!/bin/bash

# Compiler used by Spack
export SPACK_COMPILER=$SPACK_COMPILER

# MPI used by Spack
export SPACK_MPI=$SPACK_MPI

# Path to the Spack environment's view
export SPACK_ENV_VIEW=$SPACK_ENV/.spack-env/view

# Container MPI library path
HYBRID_MPI_LIB=$MPI_PATH/lib_hybrid_mpi

# Activate Spack
source /opt/spack/share/spack/setup-env.sh

# Intel compiler spack packages have different names
case \${SPACK_COMPILER} in
    oneapi@*)
        spack load intel-oneapi-compilers@\${SPACK_COMPILER#*@}
        ;;
    intel@*)
        spack load intel-oneapi-compilers-classic@\${SPACK_COMPILER#*@}
        ;;
    gcc@8.5.0)
        # System compiler
        export CC=/bin/gcc
        export CXX=/bin/g++
        export FC=/bin/gfortran
        export F90=/bin/gfortran
        ;;
    *)
        spack load \$SPACK_COMPILER
        ;;
esac

# Connect to host mpi
if [ -n "\$HOST_MPI" ]; then
    if [ -z "\${MPI_HYBRID_MODE_ONLY:-}" ]; then
        BIND_MPI_LIB=\$HOST_MPI/lib
    else
        BIND_MPI_LIB=""
    fi
fi

# Make sure container compilers are used in bind mode
export OMPI_FC=\$FC
export OMPI_CC=\$CC
export OMPI_CXX=\$CXX

# Add environment to paths
export PATH=\$SPACK_ENV_VIEW/bin:\$PATH
export CPATH=\$SPACK_ENV_VIEW/include:\$SPACK_ENV_VIEW/lib:\$CPATH

LIB_PREPEND=\$SPACK_ENV_VIEW/lib:\$BIND_MPI_LIB:\$HYBRID_MPI_LIB

export LIBRARY_PATH=\$LIB_PREPEND:\$LIBRARY_PATH
export LD_LIBRARY_PATH=\$LIB_PREPEND:\$LD_LIBRARY_PATH
export LD_RUN_PATH=\$LIB_PREPEND:\$LD_RUN_PATH
EOF


