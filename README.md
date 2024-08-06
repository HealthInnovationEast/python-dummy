# python-dummy

This is a dummy python project used when it is necessary to prevent block packages being pulled into the CodeArtifact
repository used in the SDE project.

It has no functionality other than to prevent an upstream import of the real package.

## Usage

From within the python-dummy project execute:

```
export PACKAGE=<PACKAGE_NAME_TO_BLOCK>
bash build.sh

```
