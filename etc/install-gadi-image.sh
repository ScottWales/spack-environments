#!/bin/bash

set -eu

module purge

: ${PREFIX:=/scratch/$PROJECT/$USER/ngm}
: ${VERSION:=${CI_COMMIT_BRANCH-$CI_COMMIT_SHORT_SHA:-$(git symbolic-ref --short HEAD)}}

REPO=${CI_PROJECT_URL:-$(git remote get-url origin)}
SHA=$(git rev-parse HEAD)
DATE=$(date --iso-8601=minutes)

NAME="${ENV}"
APPDIR="${PREFIX}/apps/${NAME}/${VARIANT}"
MODULE="${PREFIX}/modules/${NAME}/${VARIANT}"

echo "Installing ${NAME}/${VERSION} to ${APPDIR}"

mkdir -p "$APPDIR"
mkdir -p "$(dirname $MODULE)"

# Install image
mkdir -p "$APPDIR/etc"
cp image.sif $APPDIR/etc
cp etc/imagerun-* $APPDIR/etc

# Create bin directory and link in any binaries
mkdir -p $APPDIR/bin
rm -f $APPDIR/bin/*
cp etc/run-image-command.sh $APPDIR/bin
ln -s ../etc/imagerun-gadi $APPDIR/bin/imagerun

COMMANDS=""
# SETUP: What commands should be made available?
# All commands
# COMMANDS=$(/opt/singularity/bin/singularity exec $APPDIR/etc/image.sif ls /opt/conda/bin)
# or limited commands
# COMMANDS="cylc rose rosa rosie"
COMMANDS="$($APPDIR/bin/imagerun "/build/exportcommands.sh" || true)"
echo "COMMANDS=$COMMANDS"

for f in $COMMANDS; do
    ln -sf "run-image-command.sh" "$APPDIR/bin/$(basename $f)"
done

# Create module
sed \
    -e "s;_NAME_;${NAME};" \
    -e "s;_VERSION_;${VERSION};" \
    -e "s;_VARIANT_;${VARIANT};" \
    -e "s;_REPO_;${REPO};" \
    -e "s;_DATE_;${DATE};" \
    -e "s;_SHA_;${SHA};" \
    -e "s;_APPDIR_;${APPDIR};" \
    etc/module > "${MODULE}"

cat <<EOF
Install complete

Load module with
    module use ${PREFIX}/modules
    module load ${NAME}/${VARIANT}
EOF
