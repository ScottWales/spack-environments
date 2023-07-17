#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class Crtm(CMakePackage):
    git = "https://github.com/jcsda/crtm"
    url = "https://github.com/jcsda/crtm/archive/refs/tags/v2.3-jedi.0.tar.gz"

    version("2.3-jedi.1", sha256="10bfc99399697e3a59ad96ab15b4c3e1048e792ea901f70845e51da795522cb5")
    version("2.3-jedi.0", sha256="6cdaf191b061dd29f618569974c1c8de074fdc915bd29d05f16a94705a6e6f0e")

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')
    depends_on('netcdf-fortran')
