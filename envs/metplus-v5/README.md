# METplus Container

https://metplus.readthedocs.io/en/latest/index.html
https://met.readthedocs.io/en/latest/

To use the container at NCI:

    module use /g/data/access/ngm/modules
    module load envs/metplus/5.0

All MET commands and `run_metplus.py` will be available on PATH

## Demonstration

The demo configurations available at
[METplus Use Cases](https://metplus.readthedocs.io/en/latest/Users_Guide/usecases.html) can be run
using the container.

1. Download the sample data from https://dtcenter.ucar.edu/dfiles/code/METplus/METplus_Data/v5.0/sample_data-met_tool_wrapper-5.0.tgz and untar into a directory

2. Create a configuration file `local.conf` containing the input and output paths
```
[dir]
INPUT_BASE=/path/to/metplus_inputs
OUTPUT_BASE=/path/to/outputs
```

3. Save the demo configuration to a local file

4. Run METplus passing it both `local.conf` and the demo configuration
```
run_metplus.py local.conf ASCII2NC.conf
```

## Container Details

Commands provided by the module can be run without needing any extra
configuration. You can access the container internals with the `imagerun`
command, e.g. `imagerun ls /` will show the container contents. `imagerun
shell` will start a shell inside the container, once inside the shell run
`source /build/entrypoint.sh` to load the envionment.
