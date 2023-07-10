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
SPACK_COMPILER=$(spack find --format="{compiler}" mpi | sed 's/@=/@/')

# Move MPI libs into a separate directory for Bind mode
MPI_PATH=$SPACK_ROOT/containermpi
mkdir -p "$MPI_PATH/lib_hybrid_mpi"

if [[ "$SPACK_MPI" =~ openmpi ]]; then
    # Shift the container MPI libraries so the host libraries can shadow them if needed
    for mpilib in libmpi.so libopen-rte.so libopen-pal.so; do
        mv -v $(spack find --format="{prefix}" mpi)/lib/${mpilib}* $MPI_PATH/lib_hybrid_mpi
        rm -v $SPACK_ENV_VIEW/lib/${mpilib}*
    done

    # Put include files in a findable location
    mkdir -p "$MPI_PATH/include"
    ln -s $(spack find --format="{prefix}" mpi)/lib/*.mod $MPI_PATH/include

    # Wrapper to use the host MPIRUN etc
    mkdir -p "$MPI_PATH/bin"
    for cmd in mpirun mpiexec orted; do
        cat > "$MPI_PATH/bin/$cmd" << EOF
#!/bin/bash

if [ -n "\$HOST_MPI" ]; then
    # Use the host's $cmd
    "\$HOST_MPI/bin/$cmd" "\$@"
else
    # Use the container's $cmd
    "$(spack find --format="{prefix}" mpi)/bin/$cmd" "\$@"
fi
EOF
        chmod +x "$MPI_PATH/bin/$cmd"
    done

elif [[ "$SPACK_MPI" =~ intel-oneapi-mpi ]]; then

    ln -s $(spack find --format="{prefix}" mpi)/mpi/latest/bin "$MPI_PATH/bin"
    ln -s $(spack find --format="{prefix}" mpi)/mpi/latest/include "$MPI_PATH/include"
fi

# Create activate script
cat > $SPACK_ROOT/bin/activate.sh << EOF
#!/bin/bash

# Compiler used by Spack
export SPACK_COMPILER=$SPACK_COMPILER

# MPI used by Spack
export SPACK_MPI=$SPACK_MPI
export MPI_PATH=$MPI_PATH

# Path to the Spack environment's view
export SPACK_ENV_VIEW=$SPACK_ENV/.spack-env/view

# Container MPI library path
HYBRID_MPI_LIB=\$MPI_PATH/lib_hybrid_mpi

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

# Make sure container compilers are used in bind mode
export OMPI_CC=\$CC
export OMPI_FC=\$FC
export OMPI_F90=\$FC
export OMPI_CXX=\$CXX

export I_MPI_CC=\$CC
export I_MPI_FC=\$FC
export I_MPI_F90=\$FC
export I_MPI_CXX=\$CXX

export PATH CPATH LIBRARY_PATH LD_LIBRARY_PATH

# Add environment to paths
PATH=\$SPACK_ENV_VIEW/bin:\$PATH

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
# Connect to host mpi
if [ -n "\$HOST_MPI" ]; then
    if [ -z "\${NGMENV_MPI_HYBRID_MODE_ONLY:-}" ]; then
        BIND_MPI_LIB=\$HOST_MPI/lib
    fi
fi

# Add MPI to path & export
PATH=\$MPI_PATH/bin:\$PATH
CPATH=\$MPI_PATH/include:\$CPATH

MPI_LIB_PREPEND=\${BIND_MPI_LIB:-}:\$HYBRID_MPI_LIB
LIBRARY_PATH=\$MPI_LIB_PREPEND:\$LIBRARY_PATH
LD_LIBRARY_PATH=\$MPI_LIB_PREPEND:\$LD_LIBRARY_PATH
EOF

# Run any post-install scripts
if [ -f /build/post-install.sh ]; then
    /build/post-install.sh
fi
