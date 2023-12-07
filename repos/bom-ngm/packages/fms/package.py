class Fms(CMakePackage):
    git = "https://github.com/NOAA-GFDL/FMS"
    url = "https://github.com/NOAA-GFDL/FMS/archive/refs/tags/2023.03.tar.gz"

    version("2023.03", sha256="008a9ff394efe6a8adbcf37dd45ca103e00ae25748fc2960b7bc54f2f3b08d85")

    depends_on("ecbuild", type="build")
    depends_on("jedi-cmake", type="build")

    depends_on("mpi")
    depends_on("netcdf-fortran")

    def cmake_args(self):
        args = [
            self.define(
                "CMAKE_MODULE_PATH",
                self.spec["ecbuild"].prefix + "/share/ecbuild/cmake",
            ),
        ]

        return args
