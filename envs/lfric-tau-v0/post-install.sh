#!/bin/bash
#  Copyright 2023 Bureau of Meteorology
#  Author Scott Wales

set -eu
set -o pipefail


cat > $(spack find --format="{prefix}" fcm)/etc/fcm/keyword.cfg <<EOF
include = \$FCM_KEYWORDS
EOF
