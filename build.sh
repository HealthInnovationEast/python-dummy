#!/bin/bash
set -eu

echo "AWS_PROFILE: $AWS_PROFILE"
echo "PACKAGE: $PACKAGE"
echo "DOMAIN: $DOMAIN"
echo "REPO: $REPO"

echo -e "\nDetermining account ID..."
ACCOUNTID=$(aws sts get-caller-identity --query Account --output text | head -n 1)
echo "Account ID: $ACCOUNTID"

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
rm -rf .venv
python -m venv .venv
source .venv/*/activate
python -m pip install --upgrade build twine
echo -e '\n\n### Building package ###'
python -m build

# setup pypi repo
echo -e '\n\n### Getting codeartifact details ###'
auth_token=$(aws --profile $AWS_PROFILE codeartifact get-authorization-token --domain $DOMAIN --domain-owner $ACCOUNTID --query authorizationToken --output text)
repo_url=$(aws --profile $AWS_PROFILE codeartifact get-repository-endpoint --domain $DOMAIN --domain-owner $ACCOUNTID --repository $REPO --format pypi --query repositoryEndpoint --output text)

echo -e '\n\n### Uploading to CodeArtifact using twine ###'
export TWINE_USERNAME=aws
export TWINE_PASSWORD=$auth_token
export TWINE_REPOSITORY_URL=$repo_url
python -m twine upload --verbose --repository codeartifact dist/*

echo -e '\n\n### Cleaning up ###'
rm -rf build
