#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail

: ${SPACK_ENV_VIEW:=$SPACK_ENV/.spack-env/view}

cat > $(spack find --format="{prefix}" fcm)/etc/fcm/keyword.cfg <<EOF
include = \$FCM_KEYWORDS
EOF
