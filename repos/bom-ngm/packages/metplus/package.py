#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

from spack.package import *
import llnl.util.filesystem as fsys
import os

class Metplus(Package):
    """
    """

    homepage = "https://metplus.readthedocs.io/en/latest/"
    url = "https://github.com/dtcenter/METplus/archive/refs/tags/v5.0.1.tar.gz"

    version('5.1.0','e80df2d1059176a453b7991a9f123cb5a187cc7ba7f48a75313b92c7a0e68474')
    version('5.0.1','0e22b4f6791496551d99f68247d382b2af02c90b34c172a64c6f060e774bdced')

    depends_on('met@11:', when="@5:")
    depends_on('python')
    depends_on('rsync', type='build')

    def setup_dependent_run_environment(self, env, dependendent_spec):
        env.prepend_path('PATH', os.path.join(self.prefix, 'METplus/ush'))
        env.prepend_path('PATH', os.path.join(self.prefix, 'METviewer/bin'))

    def install(self, spec, prefix):
        sed = which("sed")
        python = spec['python'].prefix
        met = spec['met'].prefix

        install_prefix = os.path.join(prefix, 'METplus')
        which("mkdir")("-p", install_prefix)

        install = which("rsync")
        install("-a", self.stage.source_path + '/', install_prefix)

        with fsys.working_dir(install_prefix):
            which("python3")("manage_externals/checkout_externals", "--externals", "build_components/Externals.cfg")

            sed('-i', f"s:^#!/usr/bin/env python3:#!{python}/bin/python3:",
                    'ush/run_metplus.py')
            sed('-i', f"s:^#!/usr/bin/env python3:#!{python}/bin/python3:",
                    'ush/validate_config.py')
            sed('-i', f"s:^MET_INSTALL_DIR\s*=.*:MET_INSTALL_DIR = {met}:",
                    'parm/metplus_config/defaults.conf')

            sed('-i', f"s:^i\(PYTHON_ENV\)\s*=.*:\1={python}:", 
                    '../METviewer/bin/mv_batch.sh')
            sed('-i', f"s:^i\(METCALCPY_HOME\)\s*=.*:\1={prefix}/METcalcpy:", 
                    '../METviewer/bin/mv_batch.sh')
            sed('-i', f"s:^i\(METPLOTPY_HOME\)\s*=.*:\1={prefix}/METplotpy:", 
                    '../METviewer/bin/mv_batch.sh')

            sed('-i', f"s:^i\(PYTHON_ENV\)\s*=.*:\1={python}:", 
                    '../METviewer/bin/mv_load.sh')
            sed('-i', f"s:^i\(METDATAIO_HOME\)\s*=.*:\1={prefix}/METdataio:", 
                    '../METviewer/bin/mv_load.sh')

            sed('-i', f"s:^i\(PYTHON_ENV\)\s*=.*:\1={python}:", 
                    '../METviewer/bin/mv_scorecard.sh')
            sed('-i', f"s:^i\(METDATAIO_HOME\)\s*=.*:\1={prefix}/METdataio:", 
                    '../METviewer/bin/mv_scorecard.sh')
