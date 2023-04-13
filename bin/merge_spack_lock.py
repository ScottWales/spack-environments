#!/usr/bin/env python3
## Scott Wales 2023

import json
import argparse

"""
Merge Spack lock files into a single file
"""


def merge_locks(locks):
    configs = []

    for l in locks:
        with open(l) as f:
            configs.append(json.load(f))

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('inputs', nargs='+')
    parser.add_argument('output', default='spack.lock')

    args = parser.parse_args()


if __name__ == '__main__':
    main()
