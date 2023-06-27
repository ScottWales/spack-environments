class Fv3Jedi(CMakePackage):
    git = "https://github.com/jcsda/fv3-jedi"
    url = "https://github.com/jcsda/fv3-jedi/archive/refs/tags/1.1.0.tar.gz"

    version("1.1.0", sha256="aaf7b9c39bfa8ed0a8377bd1308f6d49376ec8e21f4a807497271a02c1f726bd")

    variant('fm', default="fv3core", values=('fv3core','geos','ufs'))

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')

    depends_on('netcdf-fortran')
    depends_on('ecmwf-atlas')
    depends_on('oops')
    depends_on('saber')
    depends_on('crtm')
    #depends_on('ropp-ufo')
    #depends_on('geos-aero')
    #depends_on('gsibclim')
    depends_on('ufo')
    depends_on('femps')
    #depends_on('vader')
    depends_on('mpi')
    depends_on('fv3')
    depends_on('fv3-jedi-lm fm=fv3core', when='fm=fv3core')
    depends_on('fv3-jedi-lm fm=geos', when='fm=geos')
    depends_on('fv3-jedi-lm fm=ufs', when='fm=ufs')

    patch('cmake_hdf5.patch')
    patch('cmake_disable_test.patch')

    def setup_build_environment(self, env):
        env.set('jedi_cmake_ROOT', self.spec['jedi-cmake'].prefix)

    def cmake_args(self):
        args = [
            self.define('CMAKE_MODULE_PATH', self.spec['ecbuild'].prefix + '/share/ecbuild/cmake'),
            self.define_from_variant('FV3_FORECAST_MODEL', 'fm'),
            ]

        return args
