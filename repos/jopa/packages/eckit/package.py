#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class Eckit(CMakePackage):
    git = "https://github.com/ecmwf/eckit"
    url = "https://github.com/ecmwf/eckit/archive/refs/tags/1.19.4.tar.gz"

    version("1.19.4", sha256="19f36fa6f3852a5632d22fb9cc16f2b61877206a9f49d9f5bdbbcf43b562abb8")
    version("1.19.0", sha256="a5fef36b4058f2f0aac8daf5bcc9740565f68da7357ddd242de3a5eed4765cc7")
    version("1.16.0", sha256="9e09161ea6955df693d3c9ac70131985eaf7cf24a9fa4d6263661c6814ebbaf1")

    depends_on('cmake', type='build')
    depends_on('ecbuild', type='build')

    variant('mpi', default=True)
    depends_on('mpi', when='+mpi')
    depends_on('python@3', type='build')

    def cmake_args(self):
        args = []

        args.append(self.define('PYTHON_EXECUTABLE', self.spec['python'].prefix + '/bin/python3'))

        return args
