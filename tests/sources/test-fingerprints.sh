#!/usr/bin/env bash

FAILURES=0

foo_string_hash="b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c"
bar_string_hash="7d865e959b2466918c9863afca942d0fb89d7c9ac0c99bafc3749504ded97730"
foo_bar_files_hash="ca76adad5fce9485c5ce1523e21f227b4ab8e68e96d656b09672a0febff0240d"

TMPDIR=/tmp/test-fingerprints

echo "Testing common-build-scripts in ${PWD}"
export BUILD_SCRIPTS_DIR="${PWD}"
source $BUILD_SCRIPTS_DIR/sources/fingerprints.sh
source $BUILD_SCRIPTS_DIR/sources/bash-testing.sh

function test_calculate_string_fingerprint {
  local test_name=test_calculate_string_fingerprint
  echo $test_name

  set_up_assertion "foo hash matches expected"
  assert_output_matches 'calculate_string_fingerprint foo' "$foo_string_hash"

  set_up_assertion "changed value should not match expected"
  assert_not_output_matches 'calculate_string_fingerprint "blah"' "$foo_string_hash"
}

function test_calculate_file_fingerprint {
  local test_name=test_calculate_file_fingerprint
  echo $test_name
  _create_temp_paths

  set_up_assertion "foo file hash should match foo string hash"
  assert_output_matches "calculate_file_fingerprint $TMPDIR/foo" "$foo_string_hash"


  set_up_assertion "bar file hash should match bar string hash"
  assert_output_matches "calculate_file_fingerprint $TMPDIR/bar" "$bar_string_hash"

  echo "bar" >> $TMPDIR/foo
  set_up_assertion "foo file hash should not match foo string hash after change"
  assert_not_output_matches "calculate_file_fingerprint $TMPDIR/foo" "$foo_string_hash"
}

function test_calculate_paths_fingerprint {
  local test_name=test_calculate_paths_fingerprint
  echo $test_name
  cmd="calculate_paths_fingerprint $TMPDIR/foo $TMPDIR/bar"
  _create_temp_paths
  set_up_assertion "paths should match expected fingerprint"
  assert_output_matches "$cmd" "$foo_bar_files_hash"

  echo "bar" >> $TMPDIR/foo
  set_up_assertion "changed file contents should change the fingerprint"
  assert_not_output_matches "$cmd" "$foo_bar_files_hash"
}

function test_calculate_glob_fingerprint {
  local test_name=test_calculate_glob_fingerprint
  echo $test_name
  _create_temp_paths

  set_up_assertion "glob should match expected fingerprint"
  assert_output_matches "calculate_glob_fingerprint $TMPDIR" "$foo_bar_files_hash"

  set_up_assertion "fingerprint should change if matching files change"
  echo "baz" >> $TMPDIR/baz
  assert_not_output_matches "calculate_glob_fingerprint $TMPDIR" "$foo_bar_files_hash"

  set_up_assertion "fingerprint should change if search pattern changes"
  local foo_only_aggregate_hash="5a3f57390726732146b2f29078a1c06e649b2b16d4fa1e68bc0ed1330c6440fc"
  assert_output_matches "calculate_glob_fingerprint $TMPDIR foo" "$foo_only_aggregate_hash"
}

test_calculate_string_fingerprint
test_calculate_file_fingerprint
test_calculate_paths_fingerprint
test_calculate_glob_fingerprint

finalize_tests
