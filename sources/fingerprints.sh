# This collection contains functions that
# allow you to generate fingerprints of artifacts.

BUILD_SCRIPTS_DIR=${BUILD_SCRIPTS_DIR:-$PWD/.build-scripts}
source $BUILD_SCRIPTS_DIR/sources/environment-validation.sh

function calculate_string_fingerprint {
  # Gets the SHA256 sum of an arbitrary string
  echo "$@" | sha256sum | cut -f1 -d' '
}

function calculate_file_fingerprint {
  # Gets the SHA256 sum of the contents of a file
  assert_command sha256sum
  local lockfile="$1"
  sha256sum $lockfile 2>/dev/null | cut -f1 -d' '
}

function calculate_paths_fingerprint {
  # Given a list of filenames, calculates the sha256 sum of each,
  # appending each sum to an aggregate variable, which is then
  # itself sha256-summed.
  local aggregate=""
  for lockfile in $(echo $@)
  do
    test -f "$lockfile" || continue
    lock_fingerprint=$(calculate_file_fingerprint $lockfile)
    aggregate+=$lock_fingerprint
  done
  calculate_string_fingerprint $aggregate
}

function calculate_glob_fingerprint {
  # Given a directory and an optional glob to filter,
  # generates the sha256 sum of all matching files.
  directory="$1"
  pattern="${2:-*}"
  paths=$(find "$directory" -name "$pattern" -print0 | xargs -0)
  calculate_paths_fingerprint $paths
}
