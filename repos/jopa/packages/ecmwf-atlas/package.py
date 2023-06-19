#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class EcmwfAtlas(CMakePackage):
    git = "https://github.com/ecmwf/atlas"
    url = "https://github.com/ecmwf/atlas/archive/refs/tags/0.32.1.tar.gz"

    version("0.32.1", sha256="3d1a46cb7f50e1a6ae9e7627c158760e132cc9f568152358e5f78460f1aaf01b")

    depends_on('cmake@3.12:', type='build')
    depends_on('ecbuild', type='build')
    depends_on('eckit')
