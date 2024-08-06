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

The dummy package is automatically created and built and can be found under `build/`.  This can then be uploaded using
twine to CodeArtifact (or another system).

These commands are specific to AWS CodeArtifact:

```
cd build/$PACKAGE
aws codeartifact login --tool twine --domain my_domain --domain-owner 111122223333 --repository my_repo
python -m twine upload --repository codeartifact dist/*
