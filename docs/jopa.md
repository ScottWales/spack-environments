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

2. Copy `configs/meto_vdi/*` to the Spack configuration directory (e.g. `~/.spack`)

3. Install and setup a compiler, e.g. GCC 13

```
spack install gcc@13
spack compiler find $(spack find --format='{prefix}' gcc@13)
```

4. Install the environment

```
export SPACK_COMPILER=gcc@13
export SPACK_MPI=openmpi

./bin/install.sh jopa-v0
```

5. Activate the environment

```
spack load gcc@13
spack env activate jopa-v0
export SPACK_ENV_VIEW=$SPACK_ENV/.spack-env/view
```

6. Build mo-bundle
```
cd mo-bundle

cmake --preset=bom-container --workflow
```
