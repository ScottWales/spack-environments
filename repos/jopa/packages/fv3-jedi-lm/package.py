class Fv3JediLm(CMakePackage):
    git = "https://github.com/jcsda/fv3-jedi-linearmodel"
    url = "https://github.com/jcsda/fv3-jedi-linearmodel/archive/refs/tags/1.1.0.tar.gz"

    version("1.1.0", sha256="388dfc4e2d272775b25e554277a254621a4fee8923fd6c813440eeb8be7d2742")

    variant('fm', default="fv3core", values=('fv3core','geos','ufs'))

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')

    depends_on('mpi')
    depends_on('blas')

    depends_on('fms', when='fm=fv3core')

    patch('cmake_install_modules.patch')

    def cmake_args(self):
        args = [
            self.define('CMAKE_MODULE_PATH', self.spec['ecbuild'].prefix + '/share/ecbuild/cmake'),
            self.define_from_variant('FV3_FORECAST_MODEL', 'fm'),
            ]

        return args
