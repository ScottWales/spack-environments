# Building JOPA

## With a container

1. Load the container

```
module load envs/jopa
```

2. Build Jopa inside the container

```
cd mo-bundle

imagerun cmake --preset=bom-container --workflow
```

## At the Met Office, no container

1. Install Spack, and activate with `$SPACK/share/spack/setup-env.sh`

2. Copy `configs/meto_vdi/*` to the Spack configuration directory (e.g. `~/.spack` or `$SPACK/etc/spack`)

3. Install and setup a compiler, e.g. GCC 9

```
spack install gcc@9
spack compiler find $(spack find --format='{prefix}' gcc@9)
```

4. Install the environment

```
export SPACK_COMPILER="gcc@9"
export SPACK_MPI="openmpi schedulers=slurm"

srun ./bin/install.sh jopa-v0
```

5. Activate the environment

```
spack load gcc@9
spack env activate jopa-v0
export SPACK_ENV_VIEW=$SPACK_ENV/.spack-env/view
```

6. Build mo-bundle

```
cd mo-bundle

cmake --preset=bom-container --workflow
```
