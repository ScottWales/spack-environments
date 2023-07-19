## Scott Wales 2023


class Oops(CMakePackage):
    git = "https://github.com/JCSDA/oops"
    url = "https://github.com/JCSDA/oops/archive/refs/tags/1.6.0.tar.gz"

    version(
        "1.6.0",
        sha256="3d5023690c7a11d8e2124cc477a6f413effb24a0b9f18afb33800b93236b70de",
    )
    version(
        "1.1.0",
        sha256="f3ef7d33b57246127bb9bfe63d99923b811247c72e085fabb90a7cfbc84d2ec5",
    )

    depends_on("ecbuild", type="build")
    depends_on("jedi-cmake", type="build")

    depends_on("lapack")
    depends_on("eigen")
    depends_on("mpi")
    depends_on("netcdf-fortran")
    depends_on("boost")
    depends_on("eckit")
    depends_on("fckit")
    depends_on("ecmwf-atlas")
    depends_on("nlohmann-json@3.6")
    depends_on("nlohmann-json-schema-validator")
