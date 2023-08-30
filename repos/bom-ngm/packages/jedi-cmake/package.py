#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023


class JediCmake(CMakePackage):
    git = "https://github.com/jcsda/jedi-cmake"

    version("develop", branch="develop", submodules=True)

    depends_on("ecbuild")
