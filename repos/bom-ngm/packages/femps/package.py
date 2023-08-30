class Femps(CMakePackage):
    git = "https://github.com/jcsda/femps"
    url = "https://github.com/jcsda/femps/archive/refs/tags/1.1.0.tar.gz"

    version(
        "1.1.0",
        sha256="81a888d82435903b99b4c86f798daafb3a239172ea2839493412efcc36e55312",
    )

    depends_on("ecbuild", type="build")
    depends_on("jedi-cmake", type="build")

    depends_on("netcdf-fortran")

    patch("cmake_install_modules.patch")

    def cmake_args(self):
        args = [
            self.define(
                "CMAKE_MODULE_PATH",
                self.spec["ecbuild"].prefix + "/share/ecbuild/cmake",
            ),
        ]

        return args
