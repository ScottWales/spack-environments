#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -x

NAME="$1"
REPO="$2"
TAG="$3"

URL="${REPO}/archive/refs/tags/${TAG}.tar.gz"
SHA="$(wget -q -O - "$URL" | sha256sum | cut -d ' ' -f 1)"

if ! [ -d  repos/jopa/packages/$NAME ]; then
mkdir repos/jopa/packages/$NAME
cat > repos/jopa/packages/$NAME/package.py << EOF
class ${NAME^}(CMakePackage):
    git = "${REPO}"
    url = "${URL}"

    version("$TAG", sha256="${SHA}")

    depends_on('ecbuild', type='build')
    depends_on('jedi-cmake', type='build')
EOF
else
echo "version('$TAG', sha256='${SHA}')"
fi
