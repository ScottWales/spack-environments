class Ectrans(CMakePackage):
    git = "https://github.com/ecmwf-ifs/ectrans"
    url = "https://github.com/ecmwf-ifs/ectrans/archive/refs/tags/1.2.0.tar.gz"

    version("1.2.0", sha256="2ee6dccc8bbfcc23faada1d957d141f24e41bb077c1821a7bc2b812148dd336c")

    depends_on('fiat')
    depends_on('ecbuild', type='build')
    depends_on('blas')
    depends_on('fftw')
