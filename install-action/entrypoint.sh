#!/usr/bin/env bash

ARG_VERSION_DEFAULT=latest

function print_help {
   cat <<EOF
   Use: entrypoint.sh -v 0.1.5 [--debug --help]
   Options:
   -v, --version   The version to install (default: $ARG_VERSION_DEFAULT)
   -h, --help      Show this message and exit
   -g, --debug     Show commands as they are executing
EOF
}

while (( $# ))
do
  case $1 in
    --version|-v)
      shift
      ARG_VERSION=$1
      ;;
    --help|-h)
      print_help
      exit 0
      ;;
    --debug|-g)
      set -x
      ;;
    *)
      echo "Invalid Option: $1"
      print_help
      exit 1
      ;;
  esac
  shift
done

ARG_VERSION=${ARG_VERSION:-$ARG_VERSION_DEFAULT}

function get_release_commit {
  local release="$1"
  local url_path="$release"
  if [[ "$release" != 'latest' ]]
  then
    url_path="tags/$release"
  fi
  local url="https://api.github.com/repos/uwit-iam/common-build-scripts/releases/${url_path}"
  local commit=$(curl -s $url | jq '.target_commitish' | sed 's|"||g')
  echo "$commit"
}

function get_install_script_url {
  local commit="$1"
  echo "https://raw.githubusercontent.com/UWIT-IAM/common-build-scripts/${commit}/scripts/install-common-build-scripts.sh"
}

commit=$(get_release_commit $ARG_VERSION)
url=$(get_install_script_url $commit)
export BUILD_SCRIPTS_DIR="./.build-scripts"
bash <(curl -Lsk ${url})
