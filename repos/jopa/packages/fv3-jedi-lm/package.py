class Fv3JediLm(CMakePackage):
    git = "https://github.com/jcsda/fv3-jedi-linearmodel"
    url = "https://github.com/jcsda/fv3-jedi-linearmodel/archive/refs/tags/1.1.0.tar.gz"

    version("1.1.0", sha256="388dfc4e2d272775b25e554277a254621a4fee8923fd6c813440eeb8be7d2742")

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')

    def cmake_args(self):
        args = [
            self.define('CMAKE_MODULE_PATH', self.spec['ecbuild'].prefix + '/share/ecbuild/cmake'),
            ]

        return args
