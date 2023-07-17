class Ufo(CMakePackage):
    git = "https://github.com/jcsda/ufo"
    url = "https://github.com/jcsda/ufo/archive/refs/tags/1.1.0.tar.gz"

    version(
        "1.1.0",
        sha256="7b1da8606de4f2c8a4215440dcef9a50c577666fe9acb0c4bd41939f07d23595",
    )

    variant("crtm", default=True)
    variant("rttov", default=False)
    variant("gsw", default=False)
    variant("ropp-ufo", default=False)
    variant("geos-aero", default=False)

    depends_on("ecbuild", type="build")
    depends_on("jedi-cmake", type="build")

    depends_on("mpi")
    depends_on("boost")
    depends_on("netcdf-fortran")
    depends_on("hdf5")
    depends_on("eigen@3")
    depends_on("gsl-lite")
    depends_on("eckit")
    depends_on("fckit")
    depends_on("ioda")
    depends_on("oops")

    depends_on("crtm", when="+crtm")
    # depends_on('rttov', when='+rttov')
    # depends_on('gsw', when='+gsw')
    # depends_on('ropp-ufo', when='+ropp-ufo')
    # depends_on('geos-aero', when='+geos-aero')

    patch("cmake_hdf5.patch")

    def cmake_args(self):
        args = [
            self.define(
                "CMAKE_MODULE_PATH",
                self.spec["ecbuild"].prefix + "/share/ecbuild/cmake",
            ),
        ]

        return args
