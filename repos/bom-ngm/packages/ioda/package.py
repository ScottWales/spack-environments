class Ioda(CMakePackage):
    git = "https://github.com/jcsda/ioda"
    url = "https://github.com/jcsda/ioda/archive/refs/tags/2.0.2.tar.gz"

    version(
        "2.0.2",
        sha256="2c49b46f0f73b2501fa0657f0971dfe9cfda64ed885aa6e6dbb5ecfcb132a304",
    )

    variant("boost", default=True)
    variant("odc", default=True)
    variant("python", default=False)

    depends_on("ecbuild", type="build")
    depends_on("jedi-cmake", type="build")

    depends_on("hdf5")
    depends_on("mpi")
    depends_on("eckit")
    depends_on("fckit")
    depends_on("oops")
    depends_on("eigen@3")
    depends_on("gsl-lite")
    depends_on("udunits")
    depends_on("netcdf-fortran")

    depends_on("boost", when="+boost")
    depends_on("odc", when="+odc")
    # depends_on('pybind11', when='+python')
