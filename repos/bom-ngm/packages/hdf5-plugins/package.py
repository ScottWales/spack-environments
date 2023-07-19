#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class Hdf5Plugins(CMakePackage):
    url = "https://github.com/HDFGroup/hdf5_plugins/archive/refs/tags/1.14.0.tar.gz"

    version("1.14.0", sha256="a46e747e3180cb6f6520b09e406f075fcb447192ffa2db2e4e207c3b7008284e")

    variant("zstd", default=True)

    depends_on("hdf5")
    depends_on("zlib")
    depends_on("zstd", when="+zstd")

    patch("cmake-find.patch")

    def cmake_args(self):
        args = [
                "-C",self.stage.source_path+"/config/cmake/cacheinit.cmake",
                self.define("H5PL_BUILD_TESTING", True),
                self.define("ENABLE_BLOSC", False),
                self.define("ENABLE_BZIP2", False),
                self.define("ENABLE_JPEG", False),
                self.define("ENABLE_LZ4", False),
                self.define("ENABLE_LZF", False),
                self.define("ENABLE_SZ", False),
                self.define_from_variant("ENABLE_ZSTD", "zstd"),
                ]
        return args

    def setup_build_environment(self, env):
        env.set("HDF5_ROOT", self.spec['hdf5'].prefix)
        if 'zstd' in self.spec:
            env.set("ZSTD_DIR", self.spec['zstd'].prefix)
