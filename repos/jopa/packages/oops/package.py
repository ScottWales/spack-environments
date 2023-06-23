## Scott Wales 2023

class Oops(CMakePackage):
    git = "https://github.com/JCSDA/oops"
    url = "https://github.com/JCSDA/oops/archive/refs/tags/1.6.0.tar.gz"

    version("1.6.0", sha256="3d5023690c7a11d8e2124cc477a6f413effb24a0b9f18afb33800b93236b70de")

    depends_on('cmake@3.12:', type='build')
    depends_on('ecbuild', type='build')
    depends_on('lapack')
    depends_on('eigen')
    depends_on('mpi')
    depends_on('netcdf-fortran')
    depends_on('boost')
    depends_on('eckit@1.19.0')
    depends_on('fckit')
    depends_on('ecmwf-atlas')
    depends_on('nlohmann-json')
    depends_on('nlohmann-json-schema-validator')

    def cmake_args(self):
        args = []

        args.append(self.define('MPI_Fortran_MODULE_DIR', self.spec['mpi'].prefix + '/include/Intel'))
        args.append(self.define('MPI_Fortran_LIBRARY_PATH', self.spec['mpi'].prefix + '/lib/Intel'))
        return args
