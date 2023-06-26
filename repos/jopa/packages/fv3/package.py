class Fv3(CMakePackage):
    git = "https://github.com/jcsda/GFDL_atmos_cubed_sphere"
    url = "https://github.com/jcsda/GFDL_atmos_cubed_sphere/archive/refs/tags/1.1.0.jcsda.tar.gz"

    version("1.1.0.jcsda", sha256="c591f184377712a45ad50e031f2fae9c82c40fbd7057ca774e1676039bee8842")

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')
