#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

class NciOpenmpi(Package):

    provides('mpi@:3')

    def setup_run_environment(self, env):
        # Because MPI is both a runtime and a compiler, we have to setup the
        # compiler components as part of the run environment.
        env.set("MPICC", join_path(self.prefix.bin, "mpicc"))
        env.set("MPICXX", join_path(self.prefix.bin, "mpic++"))
        env.set("MPIF77", join_path(self.prefix.bin, "mpif77"))
        env.set("MPIF90", join_path(self.prefix.bin, "mpif90"))

        # Add the compiler-specific fortran paths
        if self.spec.satisfies('%intel'):
            finc_path = join_path(self.prefix.include, "Intel")
            flib_path = join_path(self.prefix.lib, "Intel")
        elif self.spec.satisfies('%gcc'):
            finc_path = join_path(self.prefix.include, "GNU")
            flib_path = join_path(self.prefix.lib, "GNU")
        env.append_path('OMPI_FCFLAGS', '-I' + finc_path)
        env.append_path('OMPI_LDFLAGS', '-L' + self.prefix.lib + ' -L' + flib_path)

    def setup_dependent_build_environment(self, env, dependent_spec):
        self.setup_run_environment(env)

        # Use the spack compiler wrappers under MPI
        env.set("OMPI_CC", spack_cc)
        env.set("OMPI_CXX", spack_cxx)
        env.set("OMPI_FC", spack_fc)
        env.set("OMPI_F77", spack_f77)

    def setup_dependent_package(self, module, dependent_spec):
        self.spec.mpicc = join_path(self.prefix.bin, "mpicc")
        self.spec.mpicxx = join_path(self.prefix.bin, "mpic++")
        self.spec.mpifc = join_path(self.prefix.bin, "mpif90")
        self.spec.mpif77 = join_path(self.prefix.bin, "mpif77")

        self.spec.mpicxx_shared_libs = [
            join_path(self.prefix.lib, "libmpi_cxx.{0}".format(dso_suffix)),
            join_path(self.prefix.lib, "libmpi.{0}".format(dso_suffix)),
        ]
