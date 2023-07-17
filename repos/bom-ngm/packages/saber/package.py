class Saber(CMakePackage):
    git = "https://github.com/jcsda/saber"
    url = "https://github.com/jcsda/saber/archive/refs/tags/1.1.2.tar.gz"

    version("1.1.2", sha256="55cf3d7270b20d8ce7948515fe8f35be98d222c1761e2ba3f27c03021d7181ed")

    variant('oops', default=True)
    variant('gsibec', default=False)
    variant('vader', default=False)

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')

    depends_on('eckit')
    depends_on('fckit')
    depends_on('ecmwf-atlas')

    depends_on('oops', when='+oops')
    #depends_on('gsibec', when='+gsibec')
    #depends_on('vader', when='+vader')

    patch('cmake_disable_test.patch')
