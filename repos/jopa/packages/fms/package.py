class Fms(CMakePackage):
    git = "https://github.com/jcsda/FMS"
    url = "https://github.com/jcsda/FMS/archive/refs/tags/1.1.0.jcsda.tar.gz"

    version("1.1.0.jcsda", sha256="47cccea0cf107a37b1a4978d82a862404f1280af54af93b258ddc9a7b865d011")

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')
