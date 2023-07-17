#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class Fv3Bundle(CMakePackage):
    git = "https://github.com/JCSDA/fv3-bundle"
    url = "https://github.com/JCSDA/fv3-bundle/archive/refs/tags/1.1.3.tar.gz"

    version("1.1.3", sha256="ffdc7a386085201329fd6d1d83a7cbe42dd2f39c5bea65aaf0f465bfc3007178")

    depends_on('cmake@3.12:', type='build')
    depends_on('ecbuild', type='build')
    depends_on('git-lfs', type='build')

    depends_on('eckit')
    depends_on('fckit')
    depends_on('ecmwf-atlas')
    depends_on('netcdf-c')
    depends_on('netcdf-fortran')
    depends_on('eigen@3')
    depends_on('boost')
    depends_on('gsl-lite')

    variant('mpi', default=True)
    depends_on('mpi', when='+mpi')

    def cmake_args(self):
        args = [
            self.define('CMAKE_MODULE_PATH', self.spec['ecbuild'].prefix + '/share/ecbuild/cmake'),
            self.define_from_variant('ENABLE_MPI', 'mpi'),
            ]

        return args
