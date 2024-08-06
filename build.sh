#!/bin/bash
set -eu

## cleanup
rm -rf build/

echo '### Creating base files for package ###'
mkdir -p build/$PACKAGE/src/$PACKAGE
mkdir -p build/$PACKAGE/tests
cp src/python-dummy/__init__.py build/$PACKAGE/src/$PACKAGE/__init_.py
cp src/python-dummy/__init__.py build/$PACKAGE/src/$PACKAGE/blocked.py
# we don't change this file
cp README.md build/$PACKAGE/.
cp LICENSE build/$PACKAGE/.
## changes to pyproject.toml here:
cat pyproject.toml | perl -ne "\$_ =~ s/python-dummy/$PACKAGE/g; print \$_;" > build/$PACKAGE/pyproject.toml

echo -e '\n\n### Creating package build environment ###'
cd build/$PACKAGE
python -m venv .venv
source .venv/*/activate
python -m pip install --upgrade build twine
echo -e '\n\n### Building package ###'
python -m build
