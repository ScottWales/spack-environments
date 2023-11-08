#!/usr/bin/env python3
## Scott Wales 2023
import yaml


def mamba_lock_diff(filea, fileb):
    locka = yaml.safe_load(filea)
    lockb = yaml.safe_load(fileb)

    specsa = {s['hash']['sha256']: {'name': s['name'], 'version': s['version']} for s in locka['package']}
    specsb = {s['hash']['sha256']: {'name': s['name'], 'version': s['version']} for s in lockb['package']}

    namesa = {}
    namesb = {}

    for h in set(specsa.keys()) ^ set(specsb.keys()):
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

    diff = mamba_lock_diff(args.filea, args.fileb)

    if len(diff) == 0:
        return
    else:
        raise Exception(f'Specs differ: {diff}')


if __name__ == '__main__':
    main()
