#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

from spack.package import *

class Met(AutotoolsPackage):
    """
    Model Evaluation Tools

    License: Apache 2.0
    """
    homepage = "https://dtcenter.org/community-code/model-evaluation-tools-met"
    url = "https://github.com/dtcenter/MET/archive/refs/tags/v11.0.2.tar.gz"

    maintainers = ['scottwales']

    version('11.0.2', 'f720d15e1d6c235c9a41fd97dbeb0eb1082fb8ae99e1bcdcb5e51be9b50bdfbf')

    #depends_on('bufrlib')
    depends_on('netcdf-c')
    depends_on('netcdf-cxx')
    depends_on('gsl')
    #depends_on('grib2')
    #depends_on('hdf4')
    depends_on('hdf-eos2')

