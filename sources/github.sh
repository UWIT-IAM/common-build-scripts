#!/usr/bin/env bash
# This collection contains functions that
# make up for some gaps in the github cli

function get_tag_archive {
  # Downloads the source archive for a given release tag
  # If none is provided, the latest release will be downloaded
  local repository="$1"
  local release="${2:-latest}"
  local output_dir=${3:-/tmp/build-scripts}
  local gh="gh api repos/${repository}/releases"
  mkdir -p $output_dir
  if [[ "$release" == 'latest' ]]
  then
    gh="$gh/$release"
  else
    gh="$gh/tags/$release"
  fi
  url=$(eval $gh -q .tarball_url)
  tarball="$output_dir/common-build-scripts.tar.gz"
  curl -Lks "${url}" --output $tarball
  tarball_root=$(tar -tzf $tarball | sed -e 's@/.*@@' | uniq)
  tar -xf $tarball -C /tmp
  mv -v /tmp/$tarball_root/* $output_dir
}
