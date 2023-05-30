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

# Wrapper to use the host MPIRUN
mkdir "$MPI_PATH/bin"
cat > "$MPI_PATH/bin/mpirun" << EOF
#!/bin/bash

if [ -n "\$HOST_MPI" ]; then
    # Use the host's mpirun
    "\$HOST_MPI/bin/mpirun" "\$@"
else
    # Use the container's mpirun
    "$(spack find --format="{prefix}" mpi)/bin/mpirun" "\$@"
fi
EOF
chmod +x "$MPI_PATH/bin/mpirun"
ln -s "$MPI_PATH/bin/mpirun" "$MPI_PATH/bin/mpiexec"

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

CPATH=\${CPATH:-}:/include
LIBRARY_PATH=\${LIBRARY_PATH:-}:/lib64
LD_LIBRARY_PATH=\${LD_LIBRARY_PATH:-}:/lib64
EOF

for prefix in $(spack find --format '{prefix}'); do
    if ! [[ "$prefix" =~ ^$SPACK_ROOT ]]; then
        continue
    fi
    if [ -d "$prefix/include" ]; then
        echo "CPATH=$prefix/include:\$CPATH" >> $SPACK_ROOT/bin/activate.sh
    fi
    if [ -d "$prefix/lib" ]; then
        echo "LIBRARY_PATH=$prefix/lib:\$LIBRARY_PATH" >> $SPACK_ROOT/bin/activate.sh
        echo "LD_LIBRARY_PATH=$prefix/lib:\$LD_LIBRARY_PATH" >> $SPACK_ROOT/bin/activate.sh
    fi
done

cat >> $SPACK_ROOT/bin/activate.sh << EOF
# Add MPI to path & export
MPI_LIB_PREPEND=\$BIND_MPI_LIB:\$HYBRID_MPI_LIB
CPATH=$(spack find --format="{prefix}" mpi)/lib:\$CPATH
LIBRARY_PATH=\$MPI_LIB_PREPEND:\$LIBRARY_PATH
LD_LIBRARY_PATH=\$MPI_LIB_PREPEND:\$LD_LIBRARY_PATH

export CPATH LIBRARY_PATH LD_LIBRARY_PATH LD_RUN_PATH
EOF


