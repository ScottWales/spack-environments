#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class Fckit(CMakePackage):
    git = "https://github.com/ecmwf/fckit"
    url = "https://github.com/ecmwf/fckit/archive/refs/tags/0.9.0.tar.gz"

    version("0.10.1", sha256="9cde04fefa50624bf89068ab793cc2e9437c0cd1c271a41af7d54dbd37c306be")

    depends_on('cmake', type='build')
    depends_on('ecbuild', type='build')

    depends_on('eckit+mpi')
