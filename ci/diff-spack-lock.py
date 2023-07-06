#!/g/data/hh5/public/apps/miniconda3/envs/analysis3/bin/python
## Scott Wales 2023

# Compare two spack lock files, exiting with 0 if they represent the same environment

import argparse

def spack_lock_diff(filea, fileb):
    locka = json.load(filea)
    lockb = json.load(fileb)

    specsa = set(locka['concrete_specs'].keys())
    specsb = set(lockb['concrete_specs'].keys())

    diff = specsa ^ specsb

    return diff

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('filea', argparse.FileType('r'))
    parser.add_argument('fileb', argparse.FileType('r'))
    args = parser.parse_args()

    diff =  spack_lock_diff(args.filea, args.fileb):

    if len(diff) == 0:
        return
    else:
        raise Exception(f'Specs differ: {diff}')

if __name__ == '__main__':
    main()
