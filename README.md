# python-dummy

This is a dummy python project used when it is necessary to prevent block packages being pulled into the CodeArtifact
repository used in the SDE project.

It has no functionality other than to prevent an upstream import of the real package.

## Usage

1. Perform any AWS login necessary (e.g. `aws sso login`)
1. From within the python-dummy project execute:
    ```
    export AWS_PROFILE=<AWS account profile>
    export PACKAGE=<PACKAGE_NAME_TO_BLOCK>
    export DOMAIN=<codeartifact domain>
    export REPO=<codeartifact repo>
    bash build.sh
    ```

The dummy package is automatically created, built and submitted to the specified codeartifact repo
