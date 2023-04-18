#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class LfricBuildEnv(Package):

    version("2023.0")

    depends_on(f"xios@2.5.2252")
    depends_on("yaxt idxtype=long")
    depends_on("pfunit@3 max_array_rank=6 +mpi +openmp")
