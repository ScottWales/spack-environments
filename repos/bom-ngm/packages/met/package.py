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

    version('11.1.0', 'e2e371ae1f49185ff8bf08201b1a3e90864a467aa3369b04132d231213c3c9e5')
    version('11.0.2', 'f720d15e1d6c235c9a41fd97dbeb0eb1082fb8ae99e1bcdcb5e51be9b50bdfbf')

    depends_on('bufr')
    depends_on('netcdf-cxx4')
    depends_on('hdf5')
    depends_on('gsl')
    depends_on('g2c')
    depends_on('hdf@4')
    depends_on('hdf-eos2')
    depends_on('python')


    def configure_args(self):
        config_args = [
            "--enable-grib2",
            "--enable-python",
            "--enable-modis",
            "--enable-lidar2nc",
        ]

        config_args.append("MET_NETCDF=%s"%self.spec["netcdf-cxx4"].prefix)
        config_args.append("MET_HDF5=%s"%self.spec["hdf5"].prefix)
        config_args.append("MET_BUFR=%s"%self.spec["bufr"].prefix)
        config_args.append("MET_BUFRLIB=%s/lib64"%self.spec["bufr"].prefix)
        config_args.append("BUFRLIB_NAME=-lbufr_4")
        config_args.append("MET_GSL=%s"%self.spec["gsl"].prefix)
        config_args.append("MET_GRIB2CINC=%s/include"%self.spec["g2c"].prefix)
        config_args.append("MET_GRIB2CLIB=%s/lib64"%self.spec["g2c"].prefix)
        config_args.append("GRIB2CLIB_NAME=-lg2c")
        config_args.append("MET_PYTHON_CC=")
        config_args.append("MET_PYTHON_LD=-L%s/lib -lpython3.11"%self.spec["python"].prefix)
        config_args.append("MET_HDF=%s"%self.spec["hdf"].prefix)
        config_args.append("MET_HDFEOS=%s"%self.spec["hdf-eos2"].prefix)
        config_args.append("LIBS=-ltirpc")

        return config_args
