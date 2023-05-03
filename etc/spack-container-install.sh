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

# Move MPI libs into a separate directory for Bind mode
MPI_PATH=$(spack find --format="{prefix}" ${SPACK_MPI})
HYBRID_MPI_LIB="$MPI_PATH/lib_hybrid_mpi"
mkdir -pv "$HYBRID_MPI_LIB"
for mpilib in libmpi.so libopen-rte.so libopen-pal.so; do
    mv -v $MPI_PATH/lib/${mpilib}* $HYBRID_MPI_LIB
    rm -v $SPACK_ENV_ROOT/lib/${mpilib}*
done

cat > /build/spack.activate.sh << EOF
#!/bin/bash
export SPACK_COMPILER=$SPACK_COMPILER
export SPACK_MPI=$SPACK_MPI
export SPACK_ENV_VIEW=$SPACK_ENV/.spack-env/view

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
        ;;
    *)
        spack load \$SPACK_COMPILER
        ;;
esac

# Path to mount host MPI
export BIND_MPI_PATH=/host/$SPACK_MPI

# Host MPI library path
if [ -z "\${MPI_HYBRID_MODE_ONLY:-}" ]; then
    BIND_MPI_LIB=\$BIND_MPI_PATH/lib
else
    BIND_MPI_LIB=""
fi

# Container MPI library path
HYBRID_MPI_LIB=$HYBRID_MPI_LIB

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

if [ -f /build/env.activate.sh ]; then
    # Add any definitions from the environment
    source /build/env.activate.sh
fi
EOF


