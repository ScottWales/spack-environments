## Scott Wales 2023

class Oops(CMakePackage):
    git = "https://github.com/JCSDA/oops"

    version("1.6.0", commit="4f232fadf782326e2718c7cc55194511a6409476")

    depends_on('cmake@3.12:', type='build')
    depends_on('ecbuild', type='build')
    depends_on('lapack')
    depends_on('eigen')
    depends_on('mpi')
    depends_on('netcdf-fortran')
    depends_on('boost')
    depends_on('eckit')
    depends_on('fckit')
    depends_on('ecmwf-atlas')
    depends_on('nlohmann-json')
    depends_on('nlohmann-json-schema-validator')

