#!/bin/bash
set -eu

echo '### Creating base files for package ###'
mkdir -p $PACKAGE/src/$PACKAGE
mkdir -p $PACKAGE/tests
cp src/python-dummy/__init__.py $PACKAGE/src/$PACKAGE/__init_.py
cp src/python-dummy/__init__.py $PACKAGE/src/$PACKAGE/blocked.py
# we don't change this file
cp README.md $PACKAGE/.
cp LICENSE $PACKAGE/.
## changes to pyproject.toml here:
cat pyproject.toml | perl -ne "\$_ =~ s/python-dummy/$PACKAGE/g; print \$_;" > $PACKAGE/pyproject.toml

echo -e '\n\n### Creating package build environment ###'
cd $PACKAGE
python -m venv .venv
source .venv/*/activate
python -m pip install --upgrade build twine
echo -e '\n\n### Building package ###'
python -m build
