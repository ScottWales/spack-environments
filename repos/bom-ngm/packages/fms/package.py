class Fms(CMakePackage):
    git = "https://github.com/jcsda/FMS"
    url = "https://github.com/jcsda/FMS/archive/refs/tags/1.1.0.jcsda.tar.gz"

    version("2023.03", sha256="008a9ff394efe6a8adbcf37dd45ca103e00ae25748fc2960b7bc54f2f3b08d85")
    version(
        "1.1.0.jcsda",
        sha256="47cccea0cf107a37b1a4978d82a862404f1280af54af93b258ddc9a7b865d011",
    )

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
