#!/usr/bin/env python3
## Scott Wales 2023

import yaml
import json
import argparse
import os

"""
Merge Spack lock files into a single file
"""


def merge_locks(locks):
    meta = {}
    roots = []
    concrete_specs = {}

    for lf in locks:
        with open(lf) as f:
            l = json.load(f)
            meta = l['_meta']
            roots.extend(l['roots'])
            concrete_specs.update(l['concrete_specs'])

    return {'_meta': meta, 'roots': roots, 'concrete_specs': concrete_specs}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input', nargs='+')
    parser.add_argument('--ci-yaml')
    parser.add_argument('--output')

    args = parser.parse_args()
    merged = merge_locks(args.input)

    with open(os.path.join(args.output, 'spack.lock'), 'w') as f:
        json.dump(merged, f, indent=2)

    specs = [f"{r['spec']}/{r['hash']}" for r in merged['roots']]
    specs = [f"{r['spec']}" for r in merged['roots']]

    with open(args.ci_yaml) as f:
        env = yaml.load(f)

    env['spack']['specs'] = specs

    with open(os.path.join(args.output, 'spack.yaml'), 'w') as f:
        yaml.dump(env, f)


if __name__ == '__main__':
    main()
