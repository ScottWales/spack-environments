#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

from spack.package import *
import os

class Metplus(Package):
    """
    """

    homepage = "https://metplus.readthedocs.io/en/latest/"
    url = "https://github.com/dtcenter/METplus/archive/refs/tags/v5.0.1.tar.gz"

    version('5.0.1','0e22b4f6791496551d99f68247d382b2af02c90b34c172a64c6f060e774bdced')

    depends_on('met@11:', when="@5:")
    depends_on('python')

    def setup_dependent_run_environment(self, env, dependendent_spec):
        env.prepend_path('PATH', os.path.join(self.prefix, 'metplus/ush'))

    def install(self, spec, prefix):
        sed = which("sed")
        python = spec['python'].prefix
        met = spec['met'].prefix

        sed('-i', f"s:^#!/usr/bin/env python3:#!{python}/bin/python3:", 'ush/run_metplus.py')
        sed('-i', f"s:^#!/usr/bin/env python3:#!{python}/bin/python3:", 'ush/validate_config.py')
        sed('-i', f"s:^MET_INSTALL_DIR\s*=.*:MET_INSTALL_DIR = {met}:", 'parm/metplus_config/defaults.conf')

        install_prefix = os.path.join(prefix, 'metplus')
        which("mkdir")("-p", install_prefix)

        install = which("cp")
        install("-r", "metplus", install_prefix)
        install("-r", "parm", install_prefix)
        install("-r", "produtil", install_prefix)
        install("-r", "ush", install_prefix)
