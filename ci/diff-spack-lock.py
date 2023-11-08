#!/usr/bin/env python3
## Scott Wales 2023

# Compare two spack lock files, exiting with 0 if they represent the same environment

import argparse
import json

def spack_lock_diff(filea, fileb):
    locka = json.load(filea)
    lockb = json.load(fileb)

    specsa = set(locka['concrete_specs'].keys())
    specsb = set(lockb['concrete_specs'].keys())

    namesa = {}
    namesb = {}

    for h in specsa ^ specsb:
        if h in specsa:
            namesa[specsa[h]['name']] = f"{specsa[h]['name']}@{specsa[h]['version']}/{h[0:6]}"
        else:
            namesb[specsb[h]['name']] = f"{specsb[h]['name']}@{specsb[h]['version']}/{h[0:6]}"

    diff = []
    for n in sorted(set(namesa.keys()) & set(namesb.keys())):
        diff.append(f"- {namesa.get(n,'')} + {namesb.get(n,'')}")

    return "\n".join(diff)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('filea', type=argparse.FileType('r'))
    parser.add_argument('fileb', type=argparse.FileType('r'))
    args = parser.parse_args()

    diff = spack_lock_diff(args.filea, args.fileb)

    if len(diff) == 0:
        return
    else:
        raise Exception(f'Specs differ: {diff}')

if __name__ == '__main__':
    main()
