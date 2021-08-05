# common-build-scripts

Common build scripts and functions that can be invoked directly or via docker.

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
# build_scripts/foo.sh
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


Recommended method, if you have the [gh] client installed

```
# These first two commands will download the scripts and source files to `~/.common-build-scripts`
source <(curl -s https://raw.githubusercontent.com/UWIT-IAM/common-build-scripts/main/sources/github.sh)
get_tag_archive UWIT-IAM/common-build-scripts latest ~/.common-build-scripts

# The rest of these are optional and will allow you to call any function or run
# any build script from anywhere.

echo "for s in $HOME/.common-build-scripts/sources; do source $s; done" >> ~/.bashrc
echo "PATH="$PATH:$HOME/.common-build-scripts/scripts" >> ~/.bashrc
echo "export BUILD_SCRIPTS_DIR=$HOME/.common-build-scripts" >> ~/.bashrc
```

If you do not have the [gh] client installed, you can manually download and extract the version you want from 
the available [releases].

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

[gh]: https://cli.github.com/
[releases]: https://github.com/UWIT-IAM/common-build-scripts/releases
[docker repository]:  https://github.com/orgs/UWIT-IAM/packages/container/package/common-build-scripts
