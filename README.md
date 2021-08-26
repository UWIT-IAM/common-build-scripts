# common-build-scripts

Common build scripts and functions that can be invoked directly or via docker.

## Quickstart:

Install locally with:

```
# The URL below is mapped to the raw script stored on the `main` 
# branch of this repository at scripts/install-common-build-scripts.sh.

echo $(source <(curl -s https://uwiam.page.link/install-build-scripts))
```

## How to Use This

You can install these scripts on your local machine to make them avaialable to your developer workspace, 
or you can simply invoke the docker container.

### . . . from Github Actions

You can run your actions directly on the vended docker image.
The `release` and `latest` tags will always be the most recently
published release. 

You can also select a version from the past. Check the 
[docker repository] for more information.


#### Run a single command

```yml
# in your workflow.yml

steps:
  - uses: actions/checkout@v2
  - uses: docker://ghcr.io/uwit-iam/common-build-scripts:release
    with:
       args: calculate_string_fingerprint "hello!"
```

#### Run an entire script that invokes the commands

```bash
#!/usr/bin/env bash

fingerprint=$(calculate_paths_fingerprint assets)
link=$(slack_link https://fingerprints.com/$fingerprint "click here")
slack_message="To view this fingerprint, $link!"
set_ci_output slack-message "$slack_message"
```

```yml
# in your workflow.yml

steps:
  - uses: actions/checkout@v2
  - uses: docker://ghcr.io/uwit-iam/common-build-scripts:release
    with:
       args: ./build_scripts/foo.sh
```

### . . . anywhere!

#### Install to your environment


The following one-liner will install the build scripts to your local `./build-scripts`
directory. It is recommended to defer to default behavior, which installs this 
in your repository root, instead of system-wide.

You can control the build directory with the `--dirctory/-d` 
argument, and set the version with the `--version/-v` argument.

```
# The URL below is mapped to the raw script stored on the `main` 
# branch of this repository at scripts/install-common-build-scripts.sh.
echo $(source <(curl -s https://uwiam.page.link/install-build-scripts))
```

If you want to control which installer you use, you can use
the URL Format:

```
https://raw.githubusercontent.com/UWIT-IAM/common-build-scripts/REF/scripts/install-common-build-scripts.sh
```

where `${REF}` is the branch or other resolvable reference you want to use. (Mostly 
this is important if you want to install and test a new release before it is merged.)

#### Run using docker

Run a single command:

```
docker run -it ghcr.io/uwit-iam/common-build-scripts:release calculate_string_fingerprint "Hello!"
```

Mount your repository on the docker image to perform your builds:

```
docker run -it -v $PWD:/source ghcr.io/uwit-iam/common-build-scripts:release /source/foo.sh
```

#### Extend the Docker image:

This example installs the build scripts onto the UWIT-IAM poetry image, then installs project dependencies:

```
ARG CBS_VERSION=release
FROM ghcr.io/uwit-iam/common-build-scripts:${CBS_VERSION} AS build-scripts

ARG POETRY_VERSION=latest
FROM ghcr.io/uwit-iam/poetry:${POETRY_VERSION} AS builder-base
workdir /build
COPY --from=build-scripts /builder /build-scripts
COPY pyproject.toml poetry.lock ./
RUN poetry install && /builder/scripts/do_work.sh
```

## Repository Structure

```
- README.md  # This document, thanks for reading me!
+ scripts    # Things you run (e.g., `./scripts/script-name.sh`)
+ sources    # Things you source (e.g., `source ./sources/collection-name.sh`)
```

[releases]: https://github.com/UWIT-IAM/common-build-scripts/releases
[docker repository]:  https://github.com/orgs/UWIT-IAM/packages/container/package/common-build-scripts
